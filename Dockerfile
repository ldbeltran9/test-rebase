# This file is synced with stordco/common-config-elixir. Any changes will be overwritten.

ARG BUILDER_IMAGE="elixir:1.16-otp-26-alpine"
ARG RUNNER_IMAGE="gcr.io/stord-ci/app-base:3.20_2026.02.16_d8729fd"

# By default we build for a production environment, but we allow setting this build
# arg to build other environments like e2e testing.
ARG BUILD_ENV="prod"

################## BASE ##################
FROM ${BUILDER_IMAGE} AS base

# Install build tools
RUN apk --no-cache add \
  bash \
  build-base \
  git

# Install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

################## DEV ##################
FROM base AS dev

# Install development-only system dependencies
RUN apk --no-cache add \
  inotify-tools

################## BUILD ##################
FROM base AS builder

ARG BUILD_ENV

# prepare build dir
WORKDIR /app

# set build ENV
ENV MIX_ENV=${BUILD_ENV}

# install mix dependencies
COPY mix.exs mix.lock ./
RUN --mount=type=secret,id=github_token \
  --mount=type=secret,id=hex_token \
  --mount=type=secret,id=oban_fingerprint \
  --mount=type=secret,id=oban_token \
  git config --system url."https://x-access-token:$(cat /run/secrets/github_token)@github.com".insteadOf "https://github.com" && \
  mix hex.organization auth "stord" --key "$(cat /run/secrets/hex_token)" && \
  mix hex.repo add oban "https://repo.oban.pro" \
    --fetch-public-key "$(cat /run/secrets/oban_fingerprint)" \
    --auth-key "$(cat /run/secrets/oban_token)" && \
  mix deps.get --only $MIX_ENV && \
  rm -f /etc/gitconfig && \
  mix hex.organization deauth stord && \
  mix hex.repo remove oban

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
RUN mkdir config
COPY config config
RUN mix deps.compile

# Compile the release
COPY lib lib
COPY priv priv
RUN mix compile

COPY rel rel
RUN mix release

################# RELEASE ##################
FROM ${RUNNER_IMAGE}

ARG BUILD_ENV
ARG BIN_FILE=server

# Set the mix env so we have access to it for the docker script
ENV MIX_ENV=${BUILD_ENV}

# Set the locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${BUILD_ENV}/rel/example_service ./

USER nobody

WORKDIR "/app/bin"
ENV BIN_FILE=${BIN_FILE}
ENV PATH="$PATH:/app/bin"
CMD ["/bin/sh", "-c", "$BIN_FILE"]

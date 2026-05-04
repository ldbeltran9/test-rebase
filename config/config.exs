# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :example_service,
  cors_origin: ~r{localhost},
  ecto_repos: [ExampleService.Repo],
  error_topic: "example_service-service--errors",
  generators: [binary_id: true],
  healthchecks: [
    {Healthcheck.EctoCheck, name: "repo", repo: ExampleService.Repo}
  ]

config :example_service, ExampleService.Repo, telemetry_prefix: [:repo]

# Configures the endpoint
config :example_service, ExampleServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fkL5WNgUC/gTK0GgmzlJVXMu4z2Vsu6d4RxtPPKEZHDdRImoPkUXI66IuO3wf25m",
  render_errors: [view: ExampleServiceWeb.ErrorJSON, accepts: ~w(json), layout: false],
  pubsub_server: ExampleService.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger_json, :backend,
  formatter: LoggerJSON.Formatters.DatadogLogger,
  metadata: :all

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

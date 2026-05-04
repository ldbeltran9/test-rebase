# Example Service

#feature-u changes

Stord Backend example_service repo.

This is an example service that follows the same patterns of our other services. It includes:

- Kafka event handling with Kafee
- DataDog and Open Telemetry monitoring
- Github workflows
- OpenAPI
- common-config-elixir setup and working

To use it simply, simply create a new repo using this repository as a template. Then do the following text replacements:

- `ExampleService` -> `YourServiceName`
- `example_service` -> `your_service_name`
- `example-service` -> `your-service-name`

## Development

### Local

```shell
# install languages
$ asdf install

# install dependencies
$ bin/setup

# start the dev server with a shell
$ bin/start

# run the tests
$ bin/test

# lint and check formatting
$ bin/lint
```

### Docker

```shell
# build container
$ bin/docker build

# install dependencies
$ bin/docker setup

# start the dev server
$ bin/docker start

# connect to the running server with iex
$ bin/docker remote

# run the tests
$ bin/docker test

# run an arbitrary command
# $ bin/docker run <your command>

$ bin/docker run mix credo
$ bin/docker run mix format
$ bin/docker run bin/lint

# run bash
$ bin/docker run bash

# Clean and delete volumes
$ bin/docker clean
```

## Continuous Integration

example_service is configured to automatically test and deploy to nonprod using GitHub Actions.

The CI workflow runs against PUll Requests and a push to `main`. It has jobs to run credo, dialyzer, format and test.

The Deploy/NonProd workflow deploys to Nonprod and runs on push to `main` or by `workflow_dispatch`.

Deploy/Production workflow deploys to production and is triggered only by `workflow_dispatch`.

import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.

config :example_service, ExampleService.Repo,
  username: "postgres",
  password: "postgres",
  database: "example_service_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :example_service, ExampleServiceWeb.Endpoint, server: false

# Print only warnings and errors during test
config :logger, level: :warning

config :joken, default_signer: "secret"

config :opentelemetry, :processors,
  otel_batch_processor: %{
    exporter: :undefined
  }

config :example_service, ExampleServiceEvents.Producer, adapter: Kafee.Producer.TestAdapter

import Config

if log_level = System.get_env("LOG_LEVEL") do
  config :logger, level: String.to_existing_atom(log_level)
end

if System.get_env("PHX_SERVER") do
  config :example_service, ExampleServiceWeb.Endpoint, server: true
end

if config_env() == :prod do
  db_user = "DATABASE_DB_USER" |> System.get_env("postgres") |> URI.encode_www_form()
  db_pass = "DATABASE_DB_PASS" |> System.get_env("") |> URI.encode_www_form()
  db_host = System.get_env("DATABASE_DB_HOST", "localhost")
  db_port = System.get_env("DATABASE_DB_PORT", "5432")
  db_name = System.get_env("DATABASE_DB_NAME", "example_service_dev")
  db_url = "postgresql://#{db_user}:#{db_pass}@#{db_host}:#{db_port}/#{db_name}"

  config :example_service, ExampleService.Repo,
    url: db_url,
    pool_size: "POOL_SIZE" |> System.get_env("10") |> String.to_integer(),
    show_sensitive_data_on_connection_error: false

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  kafka_endpoints = [
    {
      System.fetch_env!("KAFKA_HOST"),
      "KAFKA_PORT" |> System.fetch_env!() |> String.to_integer()
    }
  ]

  kafka_sasl = {
    :plain,
    System.fetch_env!("KAFKA_USERNAME"),
    System.fetch_env!("KAFKA_PASSWORD")
  }

  config :example_service,
    elsa_supervisor: {
      Elsa.Supervisor,
      [
        endpoints: kafka_endpoints,
        connection: :example_service_conn,
        config: [sasl: kafka_sasl, ssl: true],
        group_consumer: [
          group: "example_service-service",
          topics: ["example_service-integration-bridge"],
          handler: ExampleServiceEvents.MessageHandler,
          config: [
            begin_offset: :earliest,
            offset_reset_policy: :reset_to_earliest,
            prefetch_count: 0,
            prefetch_bytes: 2 * 1024 * 1024
          ]
        ]
      ]
    }

  config :brod,
    clients: [
      kafka_client: [
        endpoints: kafka_endpoints,
        ssl: true,
        sasl: kafka_sasl,
        auto_start_producers: true
      ]
    ]

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :example_service, ExampleServiceWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :example_service, ExampleServiceWeb.Telemetry,
    statsd: [
      formatter: :datadog,
      host: System.get_env("DD_AGENT_HOST", "localhost"),
      global_tags: ["dd.internal.entity_id": System.get_env("DD_ENTITY_ID", "test")]
    ]

  config :opentelemetry_exporter,
    otlp_endpoint: System.get_env("OTEL_ENDPOINT", "http://localhost:4318")
else
  File.exists?(".env") && DotenvParser.load_file(".env")
end

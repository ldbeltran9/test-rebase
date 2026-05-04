defmodule ExampleServiceWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :example_service
  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_example_service_key",
    signing_salt: "LLUf4O/f"
  ]

  socket "/socket", ExampleServiceWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Corsica,
    origins: Application.compile_env(:example_service, :cors_origin),
    allow_headers: :all,
    expose_headers: ~w(x-request-id)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :example_service,
    gzip: false,
    only: ~w(openapi.yml)

  plug Healthcheck.Plug,
    service: "example_service"

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :example_service
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  if not Application.compile_env(:phoenix, :logger) do
    plug LoggerJSON.Plug,
      metadata_formatter: LoggerJSON.Plug.MetadataFormatters.DatadogLogger
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ExampleServiceWeb.Router
end

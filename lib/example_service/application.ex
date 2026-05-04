defmodule ExampleService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    OpentelemetryEcto.setup([:repo])
    OpentelemetryPhoenix.setup()

    children =
      [
        {Healthcheck, Application.get_env(:example_service, :healthchecks)},
        ExampleServiceWeb.Telemetry,
        ExampleService.Repo,
        {Phoenix.PubSub, name: ExampleService.PubSub},
        ExampleServiceEvents.Producer,
        ExampleServiceEvents.Consumer,
        ExampleServiceWeb.Endpoint
      ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExampleService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExampleServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

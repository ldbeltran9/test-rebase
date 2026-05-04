defmodule ExampleServiceWeb.Telemetry do
  use Supervisor

  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl Supervisor
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      # Add reporters as children of your supervision tree.
      {TelemetryMetricsStatsd, [metrics: metrics()] ++ statsd_config()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: tags([:route]),
        unit: {:native, :millisecond}
      ),
      summary("phoenix.socket_connected.duration",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_joined.duration",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_handled_in",
        tags: tags([:event]),
        unit: {:native, :millisecond}
      ),

      # Ecto Metrics
      summary("repo.query.total_time",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("repo.query.decode_time",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("repo.query.query_time",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("repo.query.queue_time",
        tags: tags(),
        unit: {:native, :millisecond}
      ),
      summary("repo.query.idle_time",
        tags: tags(),
        unit: {:native, :millisecond}
      ),

      # VM Metrics
      last_value("vm.memory.atom", tags: tags()),
      last_value("vm.memory.atom_used", tags: tags()),
      last_value("vm.memory.binary", tags: tags()),
      last_value("vm.memory.code", tags: tags()),
      last_value("vm.memory.ets", tags: tags()),
      last_value("vm.memory.processes", tags: tags()),
      last_value("vm.memory.processes_used", tags: tags()),
      last_value("vm.memory.system", tags: tags()),
      last_value("vm.memory.total", tags: tags()),
      last_value("vm.total_run_queue_lengths.io", tags: tags()),
      last_value("vm.total_run_queue_lengths.total", tags: tags()),
      last_value("vm.total_run_queue_lengths.cpu", tags: tags()),
      last_value("vm.system_counts.process_count", tags: tags()),
      last_value("vm.system_counts.port_count", tags: tags()),

      # Healthcheck Metrics
      last_value("healthcheck.status.alive", tags: tags([:check_name])),
      last_value("healthcheck.status.dead", tags: tags([:check_name]))
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {ExampleServiceWeb.Telemetry, :count_users, []}
    ]
  end

  defp statsd_config do
    :example_service
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(:statsd, [])
  end

  defp tags(tags \\ []) do
    global_tags =
      statsd_config()
      |> Keyword.get(:global_tags, [])
      |> Keyword.keys()

    global_tags ++ tags
  end
end

defmodule ExampleService.MixProject do
  use Mix.Project

  @source_url "https://github.com/stordco/example-service"

  def project do
    [
      app: :example_service,
      version: "1.0.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.circle": :test
      ],
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ExampleService.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :tls_certificate_check,
        :opentelemetry_exporter,
        :opentelemetry
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:corsica, "~> 2.1"},
      {:ecto_sql, "~> 3.7"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.8"},
      {:healthcheck, github: "stordco/healthcheck", tag: "v1.5.0"},
      {:jason, "~> 1.0"},
      {:joken, "~> 2.3"},
      {:kafee, "~> 3.0", organization: "stord"},
      {:logger_json, "~> 5.0"},
      {:opentelemetry, "~> 1.0"},
      {:opentelemetry_ecto, "~> 1.0"},
      {:opentelemetry_exporter, "~> 1.0"},
      {:opentelemetry_phoenix, "~> 1.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.1"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:scrivener_ecto, "~> 2.7"},
      {:telemetry_metrics, "~> 1.0", override: true},
      {:telemetry_metrics_statsd, "~> 0.7"},
      {:telemetry_poller, "~> 1.0"},

      # Dev & Test dependencies
      {:bypass, "~> 2.1", override: true, only: :test},
      {:cowlib, "~> 2.8", override: true},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dotenv_parser, "~> 2.0", only: [:dev, :test]},
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      checks: ["format", "credo", "dialyzer"]
    ]
  end

  defp docs do
    [
      main: "overview",
      extras: extras(),
      homepage_url: @source_url,
      source_url: @source_url,
      before_closing_body_tag: &before_closing_body_tag/1,
      nest_modules_by_prefix: [ExampleService, ExampleServiceEvents, ExampleServiceWeb]
    ]
  end

  defp extras do
    [
      "README.md": [filename: "overview", title: "Overview"]
    ]
  end

  defp before_closing_body_tag(:html) do
    """
    <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        mermaid.initialize({ startOnLoad: false });
        let id = 0;
        for (const codeEl of document.querySelectorAll("pre code.mermaid")) {
          const preEl = codeEl.parentElement;
          const graphDefinition = codeEl.textContent;
          const graphEl = document.createElement("div");
          const graphId = "mermaid-graph-" + id++;
          mermaid.render(graphId, graphDefinition, function (svgSource, bindListeners) {
            graphEl.innerHTML = svgSource;
            bindListeners && bindListeners(graphEl);
            preEl.insertAdjacentElement("afterend", graphEl);
            preEl.remove();
          });
        }
      });
    </script>
    """
  end

  defp before_closing_body_tag(_), do: ""
end

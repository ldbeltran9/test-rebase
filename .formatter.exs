# This file is synced with stordco/common-config-elixir. Any changes will be overwritten.

plugins = [] |> Enum.filter(&Code.ensure_loaded?/1)

[
  import_deps: [:ecto, :ecto_sql, :kafee, :phoenix],
  inputs: ["*.{heex,ex,exs}", "{config,lib,priv,test}/**/*.{heex,ex,exs}"],
  line_length: 120,
  plugins: plugins
]

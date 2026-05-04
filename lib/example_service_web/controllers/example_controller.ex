defmodule ExampleServiceWeb.ExampleController do
  @moduledoc false

  use ExampleServiceWeb, :controller

  @doc false
  def index(conn, _params, _current_user) do
    render(conn, :index, examples: ["example"])
  end
end

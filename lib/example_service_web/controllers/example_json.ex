defmodule ExampleServiceWeb.ExampleJSON do
  @moduledoc false

  @doc false
  def index(%{examples: examples}) do
    %{data: for(example <- examples, do: data(example))}
  end

  def show(%{example: example}) do
    %{data: data(example)}
  end

  defp data(_example) do
    %{
      id: "example-id"
    }
  end
end

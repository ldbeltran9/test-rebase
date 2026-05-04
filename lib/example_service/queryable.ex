defmodule ExampleService.Queryable do
  @callback base_query() :: Ecto.Query.t()
  @callback sort_by(Ecto.Query.t(), map()) :: Ecto.Query.t()
  @callback filter_by(Ecto.Query.t(), map()) :: Ecto.Query.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour ExampleService.Queryable
      use ExampleService.Schema

      def filtered_sorted_query(params) do
        base_query()
        |> filter_by(params)
        |> sort_by(params)
      end

      defoverridable filtered_sorted_query: 1
    end
  end
end

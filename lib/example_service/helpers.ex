defmodule ExampleService.Helpers do
  import Ecto.Query, warn: false, only: [order_by: 3]

  @default_sort "inserted_at:desc"

  def apply_sorting(query, params, allowed_fields, sort_func \\ &order_sort/2) do
    sort_by = Map.get(params, "sort", @default_sort)

    case sort_params(sort_by, allowed_fields) do
      [] ->
        @default_sort
        |> sort_params(allowed_fields)
        |> Enum.reduce(query, sort_func)

      sort_params ->
        Enum.reduce(sort_params, query, sort_func)
    end
  end

  defp order_sort({col, order}, query) do
    order_by(query, [a], [{^order, field(a, ^col)}])
  end

  defp sort_params(sort, allowed_fields) do
    sort
    |> String.split(",")
    |> Enum.reverse()
    |> Enum.reduce([], &parse_sort_field(&1, allowed_fields, &2))
  end

  defp parse_sort_field(field, allowed_fields, acc) do
    [field | order] = String.split(field, ":")

    try do
      field = String.to_existing_atom(field)

      if Enum.member?(allowed_fields, field) do
        [make_sort_tuple(field, order) | acc]
      else
        acc
      end
    rescue
      _e in ArgumentError -> acc
    end
  end

  defp make_sort_tuple(field, ["desc"]), do: {field, :desc}
  defp make_sort_tuple(field, _), do: {field, :asc}

  def current_datetime, do: DateTime.truncate(DateTime.utc_now(), :second)
end

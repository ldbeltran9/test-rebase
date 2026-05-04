defmodule ExampleService.Schema do
  @moduledoc """
  This module should be used when defining Ecto schemas and provides options that all schemas share.

  ## Example

      defmodule ExampleService.Widgets.Widget do
        use ExampleService.Schema

        @derive {Phoenix.Param, key: :widget_id}
        schema "widgets" do
          # fields
        end
      end
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      # credo:disable-for-next-line
      import Ecto.{Changeset, Query}
      import ExampleService.Helpers, only: [current_datetime: 0]

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]
    end
  end
end

defmodule ExampleServiceWeb.ErrorJSON do
  @moduledoc false

  alias ExampleServiceWeb.ErrorHelpers

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `ExampleServiceWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
  end

  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  @doc false
  def render("forbidden.json", _) do
    %{
      errors: [
        %{
          name: "permissions",
          message: "insufficient permission level"
        }
      ]
    }
  end

  def render("unauthorized.json", _) do
    %{
      errors: [
        %{
          name: "token",
          message: "expired or invalid"
        }
      ]
    }
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end

defmodule ExampleServiceWeb.ErrorJSONTest do
  use ExampleServiceWeb.ConnCase, async: true

  alias ExampleServiceWeb.ErrorJSON

  test "renders 404.json" do
    assert ErrorJSON.render("404.json", []) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500.json" do
    assert ErrorJSON.render("500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

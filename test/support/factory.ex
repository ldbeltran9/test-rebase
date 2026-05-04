# credo:disable-for-this-file
defmodule ExampleService.Factory do
  alias ExampleService.Repo

  def build(factory_name, attributes \\ %{}) do
    factory_name
    |> build()
    |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ %{}) do
    factory_name
    |> build(attributes)
    |> Repo.insert!()
  end
end

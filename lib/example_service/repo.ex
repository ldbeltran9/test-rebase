defmodule ExampleService.Repo do
  use Ecto.Repo,
    otp_app: :example_service,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 50
end

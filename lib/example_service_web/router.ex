defmodule ExampleServiceWeb.Router do
  use ExampleServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", ExampleServiceWeb do
    pipe_through [:api]

    get "/examples", ExampleController, :index
  end
end

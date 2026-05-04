# credo:disable-for-this-file
defmodule ExampleServiceWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ExampleServiceWeb, :controller
      use ExampleServiceWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  @doc """
  Returns a list of folders and files in the `priv/static` directory
  that should be served publicly.
  """
  def static_paths, do: ~w(favicon.ico robots.txt)

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:json],
        namespace: ExampleServiceWeb

      import Plug.Conn
      import ExampleServiceWeb.Gettext

      import ExampleServiceWeb.Helpers

      unquote(verified_routes())

      def action(conn, _) do
        current_user = Map.get(conn.assigns, :current_user, nil)
        args = [conn, conn.params, current_user]
        apply(__MODULE__, action_name(conn), args)
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/example_service_web/templates",
        namespace: ExampleServiceWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ExampleServiceWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ExampleServiceWeb.ErrorHelpers
      import ExampleServiceWeb.Gettext
      alias ExampleServiceWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  Adds verified route compile logic to the module.
  """
  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ExampleServiceWeb.Endpoint,
        router: ExampleServiceWeb.Router,
        statics: ExampleServiceWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

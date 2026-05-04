defmodule ExampleServiceWeb.Helpers do
  def current_user(conn),
    do: Keyword.get(conn.assigns, :current_user, nil)

  @spec pagination_view(Scrivener.Page.t()) :: map()
  def pagination_view(page) do
    %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end
end

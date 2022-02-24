defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
      <h2><%= @page.name %></h2>
      <p><%= @page.content %></p>
    """
  end

  def mount(_params, %{"id" => id} = _session, socket) do
    with id <- String.to_integer(id),
         {:ok, page} <- @page_store.fetch_by_id(id) do
      {:ok, assign(socket, page: Map.from_struct(page))}
      # {:ok, assign(socket, page: %{id: id, name: "Hello world!", content: "Test page"})}
    end
  end
end

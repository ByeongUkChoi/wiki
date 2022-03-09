defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
      <h2><%= @page.title %></h2>
      <p><%= @page.content %></p>
      <button><%= live_redirect "Edit", to: Routes.page_edit_path(@socket, :edit, @page.id) %></button>
    """
  end

  def mount(%{"id" => id} = _params, _session, socket) do
    with id <- String.to_integer(id),
         {:ok, page} <- @page_store.fetch_by_id(id) do
      {:ok, assign(socket, page: Map.from_struct(page))}
    end
  end
end

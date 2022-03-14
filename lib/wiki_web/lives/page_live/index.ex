defmodule WikiWeb.PageLive.Index do
  use WikiWeb, :live_view

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
    <aside class="menu">
      <p class="menu-label">Pages</p>
      <ul class="menu-list">
        <%= for page <- @pages do %>
          <li><%= link page.title, to: Routes.page_show_path(@socket, :show, page.id) %></li>
        <% end %>
      </ul>
    </aside>
    """
  end

  def mount(_params, _session, socket) do
    pages = @page_store.fetch_all(page_num: 1, per_page: 100)

    {:ok, assign(socket, pages: pages)}
  end
end

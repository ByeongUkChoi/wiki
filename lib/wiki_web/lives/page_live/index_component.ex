defmodule WikiWeb.PageLive.IndexComponent do
  use WikiWeb, :live_component

  def render(assigns) do
    ~H"""
      <ul class="menu-list">
        <%= for page <- @pages do %>
          <li><%= link page.title, to: Routes.page_show_path(@socket, :show, page.id) %></li>
        <% end %>
      </ul>
    """
  end
end

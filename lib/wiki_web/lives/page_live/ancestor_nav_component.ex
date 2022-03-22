defmodule WikiWeb.PageLive.AncestorNavComponent do
  use WikiWeb, :live_component

  def render(assigns) do
    ~H"""
    <nav class="breadcrumb" aria-label="breadcrumbs">
      <ul>
        <%= for ancestor <- @ancestors do %>
          <li><%= link ancestor.title, to: Routes.page_show_path(@socket, :show, ancestor.id) %></li>
        <% end %>
      </ul>
    </nav>
    """
  end
end

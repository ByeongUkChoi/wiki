defmodule WikiWeb.PageLive.IndexComponent do
  use WikiWeb, :live_component

  def render(assigns) do
    # ▶▼■
    ~H"""
      <ul class="menu-list">
        <%= for page <- @pages do %>
          <%= render_li(Map.put(assigns, :page, page)) %>
        <% end %>
      </ul>
    """
  end

  def render_li(assigns) do
    ~H"""
      <li class="columns">
      <%= if @page.has_child do %>
        <%= if is_nil(@page.children) or @page.children == [] do %>
          <a phx-click="open_child" phx-value-id={@page.id}>▶</a>
        <% else %>
          <a phx-click="open_child" phx-value-id={@page.id}>▼</a>
          <%= for page <- @page.children do %>
            <%= render_li(Map.put(assigns, :page, page)) %>
          <% end %>
        <% end %>
      <% else %>
        <a>■</a>
      <% end %>
      <%= link @page.title, to: Routes.page_show_path(@socket, :show, @page.id) %>
      </li>
    """
  end
end

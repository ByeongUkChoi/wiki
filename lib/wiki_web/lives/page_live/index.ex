defmodule WikiWeb.PageLive.Index do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
    <aside class="menu">
      <p class="menu-label">Pages</p>
      <%= render_pages(%{socket: @socket, pages: @pages}) %>
    </aside>
    """
  end

  defp render_pages(assigns) do
    ~H"""
      <ul class="menu-list">
        <%= for item <- @pages do %>
          <li>
            <a><%= item.name %></a>
            <%= if has_children?(item.children) do %>
              <%= render_pages(%{socket: @socket, pages: item.children}) %>
            <% end %>
          </li>
        <% end %>
      </ul>
    """
  end

  defp has_children?([]), do: false
  defp has_children?(c) when is_list(c), do: true
  defp has_children?(_), do: false

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       pages: [
         %{
           name: "Hello world!",
           children: [
             %{name: "Chapter 1", children: [%{name: "Chapter 1-1", children: []}]},
             %{name: "Chapter 2", children: []}
           ]
         }
       ]
     )}
  end
end

defmodule WikiWeb.PageLive.Index do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
    <ul>
      <%= for item <- @pages do %>
        <li><%= item.name %></li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, pages: [%{name: "Hello world!"}])}
  end
end

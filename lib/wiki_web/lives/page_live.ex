defmodule WikiWeb.PageLive do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
    <h2><%= @name %></h2>
    <p><%= @content %></p>
    """
  end

  def mount(%{page_id: _page_id}, _session, socket) do
    {:ok, assign(socket, page: %{name: "Hello world!", content: "Test page"})}
  end
end

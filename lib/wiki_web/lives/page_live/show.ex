defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
      <h2><%= @page.name %></h2>
      <p><%= @page.content %></p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page: %{name: "Hello world!", content: "Test page"})}
  end
end

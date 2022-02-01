defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
      <h2><%= @page.name %></h2>
      <p><%= @page.content %></p>
    """
  end

  def mount(_params, %{"id" => id} = _session, socket) do
    {:ok, assign(socket, page: %{id: id, name: "Hello world!", content: "Test page"})}
  end
end

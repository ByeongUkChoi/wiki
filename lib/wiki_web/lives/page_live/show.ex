defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
    <div style="width:25%">
      <%= live_render(@socket, WikiWeb.PageLive.Index, id: "index") %>
    </div>
    <div style="margin-left:25%">
      <h2><%= @page.name %></h2>
      <p><%= @page.content %></p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page: %{name: "Hello world!", content: "Test page"})}
  end
end

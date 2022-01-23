defmodule WikiWeb.PageLive do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
    <div style="width:25%">
      <%= live_render(@socket, WikiWeb.PageLive.Index, id: "index") %>
    </div>
    <div style="margin-left:25%">
      <%= live_render(@socket, WikiWeb.PageLive.Show, id: "show") %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end
end

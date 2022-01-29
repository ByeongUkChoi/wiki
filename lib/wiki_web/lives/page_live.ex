defmodule WikiWeb.PageLive do
  use WikiWeb, :live_view

  def render(assigns) do
    ~H"""
    <div style="width:25%">
      <%= live_render(@socket, WikiWeb.PageLive.Index, id: "index") %>
    </div>
    <div style="margin-left:25%">
      <%= render(@action, assigns) %>
    </div>
    """
  end

  defp render(:index, assigns) do
    ~H"""
    <%= live_render(@socket, WikiWeb.PageLive.Index, id: "index") %>
    """
  end

  defp render(:show, assigns) do
    ~H"""
    <%= live_render(@socket, WikiWeb.PageLive.Show, id: "show") %>
    """
  end

  defp render(:new, assigns) do
    ~H"""
    <%= live_render(@socket, WikiWeb.PageLive.New, id: "new") %>
    """
  end

  def mount(_params, %{"action" => action} = _session, socket) do
    {:ok, assign(socket, action: action)}
  end
end

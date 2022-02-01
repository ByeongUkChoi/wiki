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

  defp render(:main, assigns) do
    ~H"""
    <p>main</p>
    """
  end

  defp render(:show, %{id: id} = assigns) do
    ~H"""
    <%= live_render(@socket, WikiWeb.PageLive.Show, id: "show", session: %{"id" => id}) %>
    """
  end

  defp render(:new, assigns) do
    ~H"""
    <%= live_render(@socket, WikiWeb.PageLive.New, id: "new") %>
    """
  end

  def mount(_params, %{"action" => :show, "id" => id}, socket) do
    {:ok, assign(socket, action: :show, id: id)}
  end

  def mount(_params, %{"action" => action} = _session, socket) do
    {:ok, assign(socket, action: action)}
  end
end

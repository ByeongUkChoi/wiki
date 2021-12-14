defmodule WikiWeb.DocumentLive do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(_params, _conn, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    {:ok, assign(socket, :temperature, "test")}
  end
end

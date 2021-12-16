defmodule WikiWeb.DocumentLive.Show do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    {:ok, assign(socket, title: "Hello", author: "David", created_at: DateTime.utc_now())}
  end
end

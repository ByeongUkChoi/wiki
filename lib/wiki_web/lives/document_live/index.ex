defmodule WikiWeb.DocumentLive.Index do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    {:ok, assign(socket, :name, "test")}
  end
end

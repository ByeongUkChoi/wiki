defmodule WikiWeb.DocumentLive.Index do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    {:ok, assign(socket, items: [], page: 1, total_page: 2, per_page: 10)}
  end
end

defmodule WikiWeb.DocumentLive.Index do
  use Phoenix.LiveView

  alias WikiWeb.Router.Helpers, as: Routes

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    test_items = [
      %{
        id: 1,
        title: "Hello",
        author_name: "Tom",
        created_at: DateTime.utc_now() |> DateTime.truncate(:second)
      },
      %{
        id: 2,
        title: "World",
        author_name: "James",
        created_at: DateTime.utc_now() |> DateTime.truncate(:second)
      },
      %{
        id: 3,
        title: "Good",
        author_name: "Mike",
        created_at: DateTime.utc_now() |> DateTime.truncate(:second)
      }
    ]

    {:ok, assign(socket, items: test_items, page: 1, total_page: 1, per_page: 10)}
  end
end

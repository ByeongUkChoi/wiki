defmodule WikiWeb.DocumentLive.Index do
  use WikiWeb, :live_view

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    items = test_items()

    {:ok, assign(socket, items: items, page: 1, total_page: 1, per_page: 10)}
  end

  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end

  defp test_items() do
    titles = ["Hello", "World", "Good", "Starcraft", "Happy", "Show me the money", "Hell", "TIL"]
    authors = ["Tom", "James", "Mike", "Kim", "Lee", "Ali", "King"]
    random_title = fn titles -> Enum.random(titles) end
    random_author = fn authors -> Enum.random(authors) end

    random_time = fn ->
      DateTime.utc_now() |> DateTime.add(Enum.random(-1..-9)) |> DateTime.truncate(:second)
    end

    Enum.map(1..30, fn i ->
      %{
        id: i,
        title: random_title.(titles),
        author_name: random_author.(authors),
        created_at: random_time.()
      }
    end)
  end
end

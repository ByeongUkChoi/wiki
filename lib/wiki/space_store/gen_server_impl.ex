defmodule Wiki.SpaceStore.GenServerImpl do
  @moduledoc false

  use GenServer

  alias Wiki.SpaceStore.Space

  @behaviour Wiki.SpaceStore

  # client api
  def start_link(init_param) do
    GenServer.start_link(__MODULE__, init_param, name: __MODULE__, debug: [:trace])
  end

  @impl true
  def init(init_param) do
    {:ok, init_param}
  end

  @impl true
  def create(name: name) do
    id = next_id()
    GenServer.cast(__MODULE__, {:create, id, %{name: name}})

    with space when is_map(space) <- GenServer.call(__MODULE__, {:fetch_by_id, id}) do
      {:ok, struct(Space, space)}
    else
      _ -> {:error, :failed_create}
    end
  end

  # ====================
  # server api
  # ====================

  @impl true
  def handle_call({:fetch_by_id, id}, _from, init_param) do
    {:reply, fetch_and_put_id(init_param, id), init_param}
  end

  defp fetch_and_put_id(map, id), do: map |> Map.get(id) |> Map.put(:id, id)

  @impl true
  def handle_cast({:create, id, params}, init_param) do
    now = DateTime.utc_now()

    params =
      params
      |> Map.put(:inserted_at, now)
      |> Map.put(:updated_at, now)

    new_state = Map.update(init_param, id, params, fn _old_map -> params end)

    {:noreply, new_state}
  end

  # ====================
  # helper
  # ====================

  # TODO: gen server
  defp next_id() do
    base_date_time = 1_641_000_000

    timestamp =
      DateTime.utc_now() |> DateTime.add(base_date_time * -1) |> DateTime.to_unix(:millisecond)

    timestamp * 1000 + Enum.random(1000..9999)
  end
end

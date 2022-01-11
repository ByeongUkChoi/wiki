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
  def fetch_by_id(id) do
    with space when is_map(space) <- GenServer.call(__MODULE__, {:fetch_by_id, id}) do
      {:ok, struct(Space, space)}
    else
      _ -> {:error, :not_found}
    end
  end

  @impl true
  def fetch_all(page_num: page_num, per_page: per_page) do
    spaces = GenServer.call(__MODULE__, {:fetch_all, page_num, per_page})

    spaces
    |> Enum.map(&struct(Space, &1))
  end

  @impl true
  def get_total_count, do: GenServer.call(__MODULE__, {:get_total_count})

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

  @impl true
  def update(%Space{id: id, name: name}) do
    GenServer.cast(__MODULE__, {:update, id, %{name: name}})

    with space when is_map(space) <- GenServer.call(__MODULE__, {:fetch_by_id, id}) do
      {:ok, struct(Space, space)}
    else
      _ -> {:error, :failed_update}
    end
  end

  @impl true
  def delete_by_id(id) do
    space = GenServer.call(__MODULE__, {:fetch_by_id, id})

    with true <- is_map(space) do
      GenServer.cast(__MODULE__, {:delete_by_id, id})
      :ok
    else
      _ -> :not_found
    end
  end

  # ====================
  # server api
  # ====================

  @impl true
  def handle_call({:fetch_by_id, id}, _from, init_param) do
    {:reply, fetch_and_put_id(init_param, id), init_param}
  end

  @impl true
  def handle_call({:fetch_all, page_num, per_page}, _from, init_param) do
    start_index = (page_num - 1) * per_page
    ids = init_param |> Map.keys() |> Enum.slice(start_index, per_page)
    items = ids |> Enum.map(&fetch_and_put_id(init_param, &1))
    {:reply, items, init_param}
  end

  @impl true
  def handle_call({:get_total_count}, _from, init_param) do
    count = Enum.count(init_param, fn {k, _v} -> is_integer(k) end)
    {:reply, count, init_param}
  end

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

  @impl true
  def handle_cast({:update, id, params}, init_param) do
    updated_params =
      init_param
      |> Map.get(id)
      |> Map.merge(params)
      |> Map.put(:updated_at, DateTime.utc_now())

    new_state = Map.update(init_param, id, updated_params, fn _old_map -> updated_params end)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:delete_by_id, id}, init_param) do
    new_state = Map.delete(init_param, id)
    {:noreply, new_state}
  end

  defp fetch_and_put_id(map, id), do: map |> Map.get(id) |> Map.put(:id, id)

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

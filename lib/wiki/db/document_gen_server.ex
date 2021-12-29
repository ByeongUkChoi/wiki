defmodule Wiki.Db.GenServer do
  use GenServer

  # client api
  def start_link(init_param) do
    GenServer.start_link(__MODULE__, init_param, name: __MODULE__, debug: [:trace])
  end

  def init(init_param) do
    {:ok, init_param}
  end

  def get_all do
    GenServer.call(__MODULE__, :get_all)
  end

  # uuid
  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def save(id, params) do
    GenServer.cast(__MODULE__, {:save, id, params})
  end

  def delete(id) do
    GenServer.cast(__MODULE__, {:delete_one, id})
  end

  def delete_all do
    GenServer.cast(__MODULE__, :delete_all)
  end

  # ===============================================

  # server api

  def handle_call(:get_all, _from, init_param) do
    {:reply, init_param, init_param}
  end

  def handle_call({:get, id}, _from, init_param) do
    new_state = Map.get(init_param, id)
    {:reply, new_state, init_param}
  end

  def handle_cast({:save, id, params}, init_param) do
    new_state = Map.update(init_param, id, params, fn _old_map -> params end)

    {:noreply, new_state}
  end

  # uuid
  def handle_cast({:delete_one, id}, init_param) do
    new_state = Map.delete(init_param, String.to_atom(id))
    {:noreply, new_state}
  end

  def handle_cast(:delete_all, _init_param) do
    {:noreply, %{}}
  end
end

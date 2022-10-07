defmodule Wiki.Actor.Page do
  use GenServer

  alias Wiki.Registry

  @table :page
  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.MongoImpl)

  defp get_pid(id) do
    case GenServer.whereis({:global, {__MODULE__, id}}) do
      nil -> start_link(id)
      pid -> pid
    end
  end

  defp start_link(id) do
    page =
      case @page_store.fetch_by_id(id) do
        nil -> %{}
        page -> page
      end

    case GenServer.start_link(__MODULE__, page, {:global, {__MODULE__, id}}) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end

  def get(id) do
    case GenServer.whereis({:global, {__MODULE__, id}}) do
      nil -> start_link(id) |> elem(1)
      pid -> pid
    end
    |> GenServer.call(:get)
  end

  @spec update(integer(), %{optional(:title) => String.t(), optional(:content) => String.t()}) ::
          :ok
  def update(id, params) do
    {:ok, pid} = start_link(id)
    Map.take(params, [:title, :content])
    GenServer.cast(pid, {:update, Map.take(params, [:title, :content])})
  end

  def delete(id) do
    pid = Registry.lookup(@table, id)
    GenServer.cast(pid, :delete)
  end

  def init(page) do
    {:ok, page}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, params}, state) do
    new_state =
      params
      |> Map.take([:title, :content])
      |> Enum.reduce(state, fn {k, v}, acc_state ->
        Map.put(acc_state, k, v)
      end)

    {:noreply, new_state}
  end

  def handle_cast({:delete}, state) do
    @page_store.delete_by_id(state.id)
    {:stop, :normal, state}
  end
end

defmodule Wiki.Actor.Pages do
  use GenServer

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.MongoImpl)

  @type state :: %{
          id: integer(),
          title: String.t(),
          content: String.t(),
          parent_id: integer() | nil
        }

  @spec update(integer(), %{optional(:title) => String.t(), optional(:content) => String.t()}) ::
          :ok
  def update(id, params) do
    new_params = Map.take(params, [:title, :content])

    id
    |> get_pid()
    |> GenServer.cast({:update, new_params})
  end

  def delete(id) do
    id
    |> get_pid()
    |> GenServer.cast(:delete)
  end

  defp get_pid(id) do
    case GenServer.whereis({:global, {__MODULE__, id}}) do
      nil -> start_link(id) |> elem(1)
      pid -> pid
    end
  end

  defp start_link(id) do
    with {:ok, page} <- @page_store.fetch_by_id(id) do
      case GenServer.start_link(__MODULE__, page, name: {:global, {__MODULE__, id}}) do
        {:ok, pid} -> {:ok, pid}
        {:error, {:already_started, pid}} -> {:ok, pid}
        error -> error
      end
    else
      error -> error
    end
  end

  def init(page) do
    {:ok, page}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, params}, state) do
    new_state =
      params
      |> Map.take([:title, :content])
      |> Enum.reduce(state, fn {k, v}, acc_state ->
        Map.put(acc_state, k, v)
      end)

    @page_store.update(new_state.id, title: new_state.title, content: new_state.content)

    {:noreply, new_state}
  end

  def handle_cast({:delete}, state) do
    @page_store.delete_by_id(state.id)
    {:stop, :normal, state}
  end
end

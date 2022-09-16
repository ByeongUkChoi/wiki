defmodule Wiki.Actor.Page do
  use GenServer

  alias Wiki.Registry

  @table :page
  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.PostgreImpl)

  @spec create(%{
          optional(:title) => String.t(),
          optional(:content) => String.t(),
          optional(:parent_id) => integer() | nil
        }) :: :ok | {:error, any()}
  def create(params) do
    GenServer.start_link(__MODULE__, params)
  end

  def get(id) do
    if pid = Registry.lookup(@table, id) do
      GenServer.start_link(pid, id)
    else
      {:ok, pid} = GenServer.start_link(__MODULE__, id)
      Registry.register(@table, id, pid)
    end
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  @spec update(integer(), %{optional(:title) => String.t(), optional(:content) => String.t()}) ::
          :ok
  def update(id, params) do
    pid = Registry.lookup(@table, id)
    Map.take(params, [:title, :content])
    GenServer.cast(pid, {:update, Map.take(params, [:title, :content])})
  end

  def delete(id) do
    pid = Registry.lookup(@table, id)
    GenServer.cast(pid, :delete)
  end

  def init(%{} = params) do
    @page_store.create(title: params.title, content: params.content, parent_id: params.parent_id)
  end

  def init(id) do
    @page_store.fetch_by_id(id)
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

    @page_store.update(new_state.id, title: new_state.title, content: new_state.content)

    {:noreply, new_state}
  end

  def handle_cast({:delete}, state) do
    @page_store.delete_by_id(state.id)
    {:stop, :normal, state}
  end
end

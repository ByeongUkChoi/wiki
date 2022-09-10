defmodule Wiki.Page do
  use GenServer

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.PostgreImpl)

  def new(title: title, content: content, parent_id: parent_id) do
    GenServer.start_link(__MODULE__, title: title, content: content, parent_id: parent_id)
  end

  def get(id) do
    GenServer.start_link(__MODULE__, id)
  end

  @spec update(pid(), %{optional(:title) => String.t(), optional(:content) => String.t()}) :: :ok
  def update(pid, params) do
    Map.take(params, [:title, :content])
    GenServer.cast(pid, {:update, Map.take(params, [:title, :content])})
  end

  def init(title: title, content: content, parent_id: parent_id) do
    @page_store.create(title: title, content: content, parent_id: parent_id)
  end

  def init(id) do
    @page_store.fetch_by_id(id)
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
end

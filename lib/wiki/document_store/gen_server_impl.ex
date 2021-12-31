defmodule Wiki.DocumentStore.GenServerImpl do
  @moduledoc false

  use GenServer

  alias Wiki.DocumentStore.Document

  @behaviour Wiki.DocumentStore

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
    document = GenServer.call(__MODULE__, {:fetch_by_id, id})

    with true <- is_map(document) do
      {:ok, struct(Document, document)}
    else
      _ -> {:error, :not_found}
    end
  end

  # ===============================================
  # server api
  # ===============================================

  def handle_call({:fetch_by_id, id}, _from, init_param) do
    new_state = Map.get(init_param, id)
    {:reply, new_state, init_param}
  end
end

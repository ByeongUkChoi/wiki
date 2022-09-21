defmodule Wiki.Registry do
  use GenServer

  def start_link(_) do
    case GenServer.start_link(__MODULE__, :no_args, name: {:global, __MODULE__}) do
      {:error, {:already_started, pid}} -> {:ok, pid}
      other -> other
    end
  end

  def lookup(table, id) do
    GenServer.call({:global, __MODULE__}, {:lookup, table, id})
  end

  def register(table, id, value) do
    GenServer.cast({:global, __MODULE__}, {:register, table, id, value})
  end

  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_call({:lookup, table, id}, _from, state) do
    {:reply, get_in(state, [table, id]), state}
  end

  def handle_cast({:register, table, id, value}, state) do
    {:noreply, Map.put(state, {table, id}, value)}
  end
end

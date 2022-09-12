defmodule Wiki.Registry do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: {:global, __MODULE__})
  end

  def lookup(table, id) do
    GenServer.call({:global, __MODULE__}, {:lookup, table, id})
  end

  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_call({:lookup, table, id}, _from, state) do
    {:reply, Map.get(state, {table, id}), state}
  end
end

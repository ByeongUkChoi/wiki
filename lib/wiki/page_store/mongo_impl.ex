defmodule Wiki.PageStore.MongoImpl do

  @behaviour Wiki.PageStore

  @impl true
  def fetch_by_id(id) do
    {:ok, %Page{}}
  end
end

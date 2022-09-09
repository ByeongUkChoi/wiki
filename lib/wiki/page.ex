defmodule Wiki.Page do
  use GenServer

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.PostgreImpl)

  def start_link(title: title, content: content, parent_id: parent_id) do
    GenServer.start_link(__MODULE__, title: title, content: content, parent_id: parent_id)
  end

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(title: title, content: content, parent_id: parent_id) do
    @page_store.create(title: title, content: content, parent_id: parent_id)
  end

  def init(id) do
    @page_store.fetch_by_id(id)
  end
end

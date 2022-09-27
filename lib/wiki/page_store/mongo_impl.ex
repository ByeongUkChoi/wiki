defmodule Wiki.PageStore.MongoImpl do
  alias Wiki.PageStore.Page

  @behaviour Wiki.PageStore

  @impl true
  def fetch_by_id(id) do
    {:ok, %Page{}}
  end

  @impl true
  def fetch_all(parent_id: parent_id, page_num: page_num, page_size: page_size) do
    []
  end

  @impl true
  def fetch_all(page_num: page_num, page_size: page_size) do
    []
  end

  @impl true
  def get_total_count() do
    0
  end

  @impl true
  def create(title: title, content: content, parent_id: parent_id) do
    {:ok, %Page{}}
  end

  @impl true
  def update(id, title: title, content: content) do
    {:ok, %Page{}}
  end

  @impl true
  def delete_by_id(id) do
    :ok
  end
end

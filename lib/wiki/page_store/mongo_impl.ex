defmodule Wiki.PageStore.MongoImpl do
  alias Wiki.PageStore.Page

  @behaviour Wiki.PageStore
  @collection "pages"

  @impl true
  def fetch_by_id(id) do
    case Mongo.find_one(:mongo, @collection, %{_id: id}) do
      nil ->
        {:error, :not_found}

      page ->
        {:ok,
         %Page{
           id: page["_id"],
           title: page["title"],
           content: page["content"],
           parent_id: page["parent_id"]
         }}
    end
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
    page = %Page{title: title, content: content, parent_id: parent_id}

    Mongo.insert_one(:mongo, @collection, Mongo.Encoder.encode(page))
    {:ok, page}
  end

  @impl true
  def update(id, title: title, content: content) do
    Mongo.update_one(:mongo, @collection, %{_id: id}, %{"$set": %{title: title, content: content}})

    {:ok, %Page{}}
  end

  @impl true
  def delete_by_id(id) do
    Mongo.delete_one(:mongo, @collection, %{_id: id})
    :ok
  end
end

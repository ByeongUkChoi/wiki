defmodule Wiki.Pages do
  alias Wiki.Actor.Page

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.MongoImpl)

  @spec get(any) :: {:error, :not_found} | {:ok, Page.t()}
  def get(id) do
    @page_store.fetch_by_id(id)
  end

  @spec get_all(integer(), integer()) :: list(PageIndex.t())
  def get_all(page_num, page_size) do
    @page_store.fetch_all(page_num: page_num, per_page: page_size)
  end

  @spec get_all(integer(), integer(), integer()) :: list(PageIndex.t())
  def get_all(parent_id, page_num, page_size) do
    @page_store.fetch_all(parent_id: parent_id, page_num: page_num, per_page: page_size)
  end

  def create(title, content, parent_id) do
    {:ok, pid} = PageActor.create(%{title: title, content: content, parent_id: parent_id})
  end

  def delete(id) do
    PageActor.delete(id)
  end

  def update(id, title, content) do
    PageActor.update(id, %{title: title, content: content})

    get(id)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Wiki.PubSub, "pages")
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(Wiki.PubSub, "pages:#{id}")
  end

  def broadcast(id, event) do
    Phoenix.PubSub.broadcast(Wiki.PubSub, "pages:#{id}", event)
  end

  def broadcast(event) do
    Phoenix.PubSub.broadcast(Wiki.PubSub, "pages", event)
  end
end

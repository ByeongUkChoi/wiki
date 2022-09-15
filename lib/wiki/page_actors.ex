defmodule Wiki.PageActors do
  alias Wiki.Actor.Page, as: PageActor

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.PostgreImpl)

  @spec get(any) :: {:error, :not_found} | {:ok, Page.t()}
  def get(id) do
    PageActor.get(id)
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
    @page_store.create(title: title, content: content, parent_id: parent_id)
  end

  def delete(id) do
    @page_store.delete_by_id(id)
  end

  def update(id, title, content) do
    @page_store.update(id, title: title, content: content)
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

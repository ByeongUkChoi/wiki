defmodule WikiWeb.PageLive.Index do
  use WikiWeb, :live_view

  alias WikiWeb.PageLive.IndexComponent

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.PostgreImpl)

  def render(assigns) do
    ~H"""
    <aside class="menu">
      <p class="menu-label">Pages</p>
      <.live_component module={IndexComponent} id="index" pages={@pages} />
    </aside>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Wiki.PubSub, "pages")
    pages = @page_store.fetch_all(parent_id: nil, page_num: 1, per_page: 100)

    {:ok, assign(socket, pages: pages)}
  end

  def handle_event("open_child", %{"id" => id}, %{assigns: %{pages: pages}} = socket) do
    parent_id = String.to_integer(id)
    children = @page_store.fetch_all(parent_id: parent_id, page_num: 1, per_page: 100)

    pages_with_children =
      pages
      |> Enum.map(fn page ->
        if page.id == parent_id do
          struct(page, children: children)
        else
          page
        end
      end)

    {:noreply, assign(socket, pages: pages_with_children)}
  end

  def handle_info(event, socket) when event in [:page_created, :page_edited] do
    pages = @page_store.fetch_all(parent_id: nil, page_num: 1, per_page: 100)

    {:noreply, assign(socket, pages: pages)}
  end

  def handle_info(_event, socket) do
    {:noreply, socket}
  end
end

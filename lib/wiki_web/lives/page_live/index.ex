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
    pages = @page_store.fetch_all(parent_id: nil, page_num: 1, per_page: 100)

    {:ok, assign(socket, pages: pages)}
  end
end

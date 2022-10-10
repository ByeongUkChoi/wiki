defmodule WikiWeb.PageLive.Index do
  use WikiWeb, :live_view

  alias WikiWeb.PageLive.IndexComponent
  alias Wiki.Pages

  def render(assigns) do
    ~H"""
    <aside class="menu">
      <p class="menu-label">Pages</p>
      <.live_component module={IndexComponent} id="index" pages={@pages} />
    </aside>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Pages.subscribe()
    pages = Pages.get_all(1, 100)

    {:ok, assign(socket, pages: pages)}
  end

  def handle_event("open_child", %{"id" => id}, %{assigns: %{pages: pages}} = socket) do
    parent_id = Transformer.to_integer_or(id)
    children = Pages.get_all(parent_id, 1, 100)

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
    pages = Pages.get_all(1, 100)

    {:noreply, assign(socket, pages: pages)}
  end

  def handle_info(_event, socket) do
    {:noreply, socket}
  end
end

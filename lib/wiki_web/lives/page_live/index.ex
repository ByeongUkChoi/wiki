defmodule WikiWeb.PageLive.Index do
  use WikiWeb, :live_view

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <aside class="menu">
      <p class="menu-label">Pages</p>
      <%= render_pages(%{socket: @socket, pages: @pages}) %>
    </aside>
    """
  end

  defp render_pages(%{pages: []}) do
  end

  defp render_pages(assigns) do
    ~H"""
      <ul class="menu-list">
        <%= for page <- @pages do %>
          <%= render_page(%{socket: @socket, page: page}) %>
        <% end %>
      </ul>
    """
  end

  # ▼ ► ●
  defp render_page(assigns) do
    ~H"""
      <li>
        <%= render_index_button(%{socket: @socket, page: @page}) %>
        <%= live_patch @page.name, to: Routes.page_path(@socket, :index), style: "display: inline" %>
        <%= render_pages(%{socket: @socket, pages: @page.children}) %>
      </li>
    """
  end

  defp render_index_button(assigns) do
    ~H"""
      <%= if @page.has_children and @page.children == [] do %>
        <span phx-click={JS.push("show_children", value: %{id: @page.id})}>►</span>
      <% end %>
      <%= if @page.has_children and @page.children != [] do %>
        <span phx-click={JS.push("hide_children", value: %{id: @page.id})}>▼</span>
      <% end %>
      <%= if @page.has_children == false do %>
        <span>●</span>
      <% end %>
    """
  end

  def handle_event("show_children", %{"id" => page_id}, %{assigns: %{pages: pages}} = socket) do
    IO.inspect(123)
    pages = append_children(pages, page_id)

    {:noreply, assign(socket, pages: pages)}
  end

  def handle_event("hide_children", %{"id" => page_id}, %{assigns: %{pages: pages}} = socket) do
    pages = remove_children(pages, page_id)

    {:noreply, assign(socket, pages: pages)}
  end

  def mount(_params, %{"id" => id} = _session, socket) do
    pages = get_pages(nil)
    pages = append_children(pages, id)

    {:ok, assign(socket, pages: pages)}
  end

  defp append_children(pages, nil) do
    pages
  end

  defp append_children(pages, id) do
    Enum.map(pages, fn page ->
      case page do
        %{id: ^id} -> Map.put(page, :children, get_pages(id))
        _ -> page
      end
    end)
  end

  defp remove_children(pages, id) do
    Enum.map(pages, fn page ->
      case page do
        %{id: ^id} -> Map.put(page, :children, [])
        _ -> page
      end
    end)
  end

  # test data
  defp get_pages(parent_id) do
    pages = all_pages()

    pages
    |> Enum.filter(&(&1.parent_id == parent_id))
    |> Enum.map(&Map.put(&1, :children, []))
    |> Enum.map(&Map.put(&1, :opened, true))
  end

  defp all_pages do
    [
      %{id: 1, name: "Ch 1", parent_id: nil, has_children: true},
      %{id: 2, name: "Ch 2", parent_id: nil, has_children: false},
      %{id: 3, name: "Ch 3", parent_id: nil, has_children: false},
      %{id: 4, name: "Ch 4", parent_id: nil, has_children: false},
      %{id: 5, name: "Ch 5", parent_id: nil, has_children: false},
      %{id: 6, name: "Ch 1-1", parent_id: 1, has_children: false},
      %{id: 7, name: "Ch 1-2", parent_id: 1, has_children: true},
      %{id: 8, name: "Ch 1-3", parent_id: 1, has_children: false},
      %{id: 9, name: "Ch 1-2-1", parent_id: 7, has_children: false},
      %{id: 10, name: "Ch 1-2-2", parent_id: 7, has_children: false},
      %{id: 11, name: "Ch 3-1", parent_id: 7, has_children: false}
    ]
  end
end

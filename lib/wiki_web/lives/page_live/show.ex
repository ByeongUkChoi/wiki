defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  alias WikiWeb.PageLive.AncestorNavComponent
  alias Wiki.Pages

  def render(assigns) do
    ~H"""
    <div class="container">
      <.live_component module={AncestorNavComponent} id="ancestors" ancestors={@ancestors} />
      <h2 class="title"><%= @page.title %></h2>
      <div class="content"><%= @page.content %></div>
      <%= if @page.children != [] do %>
        <div class="buttons">
          <%= for child <- @page.children do %>
            <button class="button"><%= live_redirect child.title, to: Routes.page_show_path(@socket, :show, child.id) %></button>
          <% end %>
        </div>
      <% end %>
      <div class="buttons">
        <button class="button is-primary is-light"><%= live_redirect "Edit", to: Routes.page_edit_path(@socket, :edit, @page.id) %></button>
        <button class="button is-info is-light"><%= live_redirect "Create sub page", to: Routes.page_new_path(@socket, :new, parent_id: @page.id) %></button>
        <button class="button is-danger is-light" phx-click="delete">Delete</button>
      </div>
    </div>
    """
  end

  def mount(%{"id" => id_str} = _params, _session, socket) do
    id = Transformer.to_integer_or(id_str)
    if connected?(socket), do: Pages.subscribe(id)

    case get_page_with_children(id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Not found page!")
         |> push_redirect(to: Routes.page_index_path(socket, :index))}

      page ->
        {:ok, assign(socket, page: page, ancestors: get_ancestors(page))}
    end
  end

  defp get_ancestors(page, ancestors \\ [])

  defp get_ancestors(%{parent_id: nil}, ancestors) do
    ancestors
  end

  defp get_ancestors(%{parent_id: parent_id}, ancestors) do
    {:ok, parent} = Pages.get(parent_id)
    get_ancestors(parent, [parent | ancestors])
  end

  def handle_event("delete", _value, %{assigns: %{page: %{id: id}}} = socket) do
    with :ok <- Pages.delete(id) do
      Pages.broadcast(id, :page_edited)
      Pages.broadcast(:page_edited)

      {:noreply,
       socket
       |> put_flash(:info, "page deleted")
       |> push_redirect(to: Routes.page_new_path(socket, :new))}
    end
  end

  def handle_info(:page_edited, socket) do
    {:noreply, update(socket, :page, fn _ -> get_page_with_children(socket.assigns.page.id) end)}
  end

  def handle_info(event, socket) when event in [:child_page_created, :child_page_edited] do
    {:noreply, update(socket, :page, fn _ -> get_page_with_children(socket.assigns.page.id) end)}
  end

  defp get_page_with_children(id) do
    case Pages.get(id) do
      {:ok, page} -> Map.put(page, :children, Pages.get_all(id, 1, 100))
      _ -> nil
    end
  end
end

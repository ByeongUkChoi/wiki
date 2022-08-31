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
      <%= if @has_child do %>
        <div class="buttons">
          <button class="button">Button</button>
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

  def mount(%{"id" => id} = _params, _session, socket) do
    if connected?(socket), do: Pages.subscribe(id)

    with id <- String.to_integer(id),
         {:ok, page} <- Pages.get(id) do
      ancestors = get_ancestors(page)

      {:ok,
       assign(socket, page: Map.from_struct(page), ancestors: ancestors, has_child: has_child?(id))}
    else
      _ ->
        {:ok,
         socket
         |> put_flash(:error, "Not found page!")
         |> push_redirect(to: Routes.page_index_path(socket, :index))}
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

  defp has_child?(id) do
    Pages.get_all(id, 1, 1) != []
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
    {:ok, page} = Pages.get(socket.assigns.page.id)

    socket =
      socket
      |> update(:page, fn _ -> Map.from_struct(page) end)
      |> update(:ancestors, fn _ -> get_ancestors(page) end)

    {:noreply, socket}
  end
end

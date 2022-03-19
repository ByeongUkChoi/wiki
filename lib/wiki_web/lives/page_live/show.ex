defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
    <div class="container">
      <nav class="breadcrumb" aria-label="breadcrumbs">
        <ul>
          <%= for ancestor <- @ancestors do %>
            <li><%= link ancestor.title, to: Routes.page_show_path(@socket, :show, ancestor.id) %></li>
          <% end %>
        </ul>
      </nav>
      <h2 class="title"><%= @page.title %></h2>
      <div class="content"><%= @page.content %></div>
      <div class="buttons">
        <button class="button is-primary is-light"><%= live_redirect "Edit", to: Routes.page_edit_path(@socket, :edit, @page.id) %></button>
        <button class="button is-info is-light"><%= live_redirect "Create sub page", to: Routes.page_new_path(@socket, :new, parent_id: @page.id) %></button>
        <button class="button is-danger is-light" phx-click="delete">Delete</button>
      </div>
    </div>
    """
  end

  def mount(%{"id" => id} = _params, _session, socket) do
    with id <- String.to_integer(id),
         {:ok, page} <- @page_store.fetch_by_id(id) do
      ancestors = get_ancestors(page)

      {:ok, assign(socket, page: Map.from_struct(page), ancestors: ancestors)}
    end
  end

  defp get_ancestors(page, ancestors \\ [])

  defp get_ancestors(%{parent_id: nil}, ancestors) do
    ancestors
  end

  defp get_ancestors(%{parent_id: parent_id}, ancestors) do
    {:ok, parent} = @page_store.fetch_by_id(parent_id)
    get_ancestors(parent, [parent | ancestors])
  end

  def handle_event("delete", _value, %{assigns: %{page: %{id: id}}} = socket) do
    with :ok <- @page_store.delete_by_id(id) do
      {:noreply,
       socket
       |> put_flash(:info, "page deleted")
       |> push_redirect(to: Routes.page_new_path(socket, :new))}
    end
  end
end

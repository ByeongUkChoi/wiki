defmodule WikiWeb.PageLive.Show do
  use WikiWeb, :live_view

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
    <div class="container">
      <h2 class="title"><%= @page.title %></h2>
      <div class="content"><%= @page.content %></div>
      <div class="buttons">
        <button class="button is-primary is-light"><%= live_redirect "Edit", to: Routes.page_edit_path(@socket, :edit, @page.id) %></button>
        <button class="button is-danger is-light" phx-click="delete">Delete</button>
      </div>
    </div>
    """
  end

  def mount(%{"id" => id} = _params, _session, socket) do
    with id <- String.to_integer(id),
         {:ok, page} <- @page_store.fetch_by_id(id) do
      {:ok, assign(socket, page: Map.from_struct(page))}
    end
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

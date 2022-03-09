defmodule WikiWeb.PageLive.Edit do
  use WikiWeb, :live_view

  import Ecto.Changeset

  alias Wiki.PageStore.Page

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
    <.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
      <%= label f, :title %>
      <%= text_input f, :title, phx_debounce: "blur" %>
      <%= error_tag f, :title %>

      <%= label f, :content %>
      <%= textarea f, :content, phx_debounce: "blur" %>
      <%= error_tag f, :content %>

      <div>
        <%= submit "Post", phx_disable_with: "Posting..." %>
      </div>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: change(%Page{}))}
  end

  def handle_event("validate", %{"page" => page}, socket) do
    changeset =
      %Page{}
      |> Page.changeset(page)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"page" => params}, %{assigns: %{page: page}} = socket) do
    changed_page = page |> Page.changeset(params) |> Ecto.Changeset.apply_changes()

    with {:ok, _} <- @page_store.update(changed_page) do
      {:noreply,
       socket
       |> put_flash(:info, "page updated")
       |> push_redirect(to: Routes.page_show_path(socket, :show, changed_page.id))}
    end
  end
end

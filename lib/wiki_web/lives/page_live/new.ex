defmodule WikiWeb.PageLive.New do
  use WikiWeb, :live_view

  import Ecto.Changeset

  alias Wiki.PageStore.Page

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
    <div class="container">
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
        <div class="field">
          <%= label f, :title, class: "label" %>
          <div class="control">
              <%= text_input f, :title, phx_debounce: "blur", class: "input" %>
              <%= error_tag f, :title %>
          </div>
        </div>
        <div class="field">
          <%= label f, :content, class: "label" %>
          <div class="control">
            <%= textarea f, :content, phx_debounce: "blur", class: "textarea" %>
            <%= error_tag f, :content %>
          </div>
        </div>
        <div class="field is-grouped">
          <div class="control">
            <%= submit "Post", phx_disable_with: "Posting...", class: ["button", "is-link"] %>
          </div>
        </div>
      </.form>
    </div>
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

  def handle_event("save", %{"page" => %{"title" => title, "content" => content}}, socket) do
    with {:ok, %{id: page_id}} <- @page_store.create(title: title, content: content) do
      {:noreply,
       socket
       |> put_flash(:info, "page created")
       |> push_redirect(to: Routes.page_show_path(socket, :show, page_id))}
    end
  end
end

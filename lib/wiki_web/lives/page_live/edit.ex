defmodule WikiWeb.PageLive.Edit do
  use WikiWeb, :live_view

  alias Wiki.Pages
  alias Wiki.PageStore.Page

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

  def mount(%{"id" => id} = _params, _session, socket) do
    with id <- String.to_integer(id),
         {:ok, page} <- Pages.get(id) do
      changeset = page |> Page.changeset(%{}) |> Map.put(:action, :update)
      {:ok, assign(socket, page: page, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"page" => page}, socket) do
    changeset =
      %Page{}
      |> Page.changeset(page)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "save",
        %{"page" => %{"title" => title, "content" => content}},
        %{assigns: %{page: %{id: id}}} = socket
      ) do
    with {:ok, _} <- Pages.update(id, title, content) do
      Pages.broadcast(id, :page_edited)
      Pages.broadcast(:page_edited)

      {:noreply,
       socket
       |> put_flash(:info, "page updated")
       |> push_redirect(to: Routes.page_show_path(socket, :show, id))}
    end
  end
end

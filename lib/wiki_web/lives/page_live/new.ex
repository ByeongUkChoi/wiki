defmodule WikiWeb.PageLive.New do
  use WikiWeb, :live_view

  alias WikiWeb.PageLive.AncestorNavComponent
  alias Wiki.PageStore.Page
  alias Wiki.Actor.Page, as: PageActor
  alias Wiki.PageEvent

  def render(assigns) do
    ~H"""
    <div class="container">
      <.live_component module={AncestorNavComponent} id="ancestors" ancestors={@ancestors} />
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
        <%= hidden_input f, :parent_id, value: @parent_id %>
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

  def mount(params, _session, socket) do
    parent_id = Transformer.to_integer_or(params["parent_id"])
    ancestors = get_ancestors(parent_id)
    {:ok, assign(socket, changeset: %Page{}, parent_id: parent_id, ancestors: ancestors)}
  end

  defp get_ancestors(parent_id, ancestors \\ [])

  defp get_ancestors(nil, ancestors) do
    ancestors
  end

  defp get_ancestors(parent_id, ancestors) do
    {:ok, parent} = PageActor.get(parent_id)
    get_ancestors(parent.parent_id, [parent | ancestors])
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
        %{"page" => %{"title" => title, "content" => content, "parent_id" => parent_id_str}},
        socket
      ) do
    parent_id = Transformer.to_integer_or(parent_id_str)

    with {:ok, %{id: page_id}} <- PageActor.create(title, content, parent_id) do
      PageEvent.broadcast(:page_created)

      if parent_id != nil do
        PageEvent.broadcast(parent_id, :child_page_created)
      end

      {:noreply,
       socket
       |> put_flash(:info, "page created")
       |> push_redirect(to: Routes.page_show_path(socket, :show, page_id))}
    end
  end
end

defmodule WikiWeb.PageLive.New do
  use WikiWeb, :live_view

  import Ecto.Changeset

  alias Wiki.PageStore.Page

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
    parent_id = params["parent_id"] |> parse_integer()
    ancestors = get_ancestors(parent_id)
    {:ok, assign(socket, changeset: change(%Page{}), parent_id: parent_id, ancestors: ancestors)}
  end

  defp get_ancestors(parent_id, ancestors \\ [])

  defp get_ancestors(nil, ancestors) do
    ancestors
  end

  defp get_ancestors(parent_id, ancestors) do
    {:ok, parent} = @page_store.fetch_by_id(parent_id)
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
        %{"page" => %{"title" => title, "content" => content, "parent_id" => parent_id}},
        socket
      ) do
    with {:ok, %{id: page_id}} <-
           @page_store.create(title: title, content: content, parent_id: parse_integer(parent_id)) do
      {:noreply,
       socket
       |> put_flash(:info, "page created")
       |> push_redirect(to: Routes.page_show_path(socket, :show, page_id))}
    end
  end

  defp parse_integer(nil), do: nil
  defp parse_integer(""), do: nil
  defp parse_integer(int) when is_integer(int), do: int

  defp parse_integer(str) when is_binary(str) do
    Integer.parse(str)
    |> case do
      {int, _} -> int
      _ -> nil
    end
  end
end

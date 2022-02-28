defmodule WikiWeb.PageLive.New do
  use WikiWeb, :live_view

  @page_store Application.compile_env(:wiki, :page_store, Wiki.PageStore.GenServerImpl)

  def render(assigns) do
    ~H"""
    <div class="field">
      <label class="label">Title</label>
      <div class="control">
        <input class="input" type="text" placeholder="Text input">
      </div>
    </div>

    <div class="field">
      <label class="label">Content</label>
      <div class="control">
        <textarea class="textarea" placeholder="Textarea"></textarea>
      </div>
    </div>

    <div class="field is-grouped">
      <div class="control">
        <button class="button is-link">Submit</button>
      </div>
      <div class="control">
        <button class="button is-link is-light">Cancel</button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end

  def handle_event("save", %{"page" => %{"title" => title, "content" => content}}, socket) do
    with {:ok, %{id: page_id}} <- @page_store.create(title: title, content: content) do
      {:noreply,
       socket
       |> put_flash(:info, "page created")
       |> push_redirect(to: Routes.page_new_path(socket, :new, page_id))}
    end
  end
end

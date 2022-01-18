defmodule WikiWeb.DocumentLive.Show do
  use WikiWeb, :live_view

  @document_store Application.compile_env(
                    :wiki,
                    :document_store,
                    Wiki.DocumentStore.GenServerImpl
                  )

  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end

  def handle_params(%{"project_id" => project_id, "id" => id}, _url, socket) do
    with id <- String.to_integer(id),
         {:ok, document} <- @document_store.fetch_by_id(id) do
      attrs =
        document
        |> Map.from_struct()
        |> Map.put(:project_id, project_id)

      {:noreply, socket |> assign(attrs)}
    end
  end
end

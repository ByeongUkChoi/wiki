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

  def handle_params(%{"id" => id}, _url, socket) do
    with id <- String.to_integer(id),
         {:ok, document} <- @document_store.fetch_by_id(id) do
      {:noreply, socket |> assign(Map.from_struct(document))}
    end
  end
end

defmodule WikiWeb.DocumentLive.New do
  use WikiWeb, :live_view

  import Ecto.Changeset

  alias Wiki.DocumentStore.Document

  @document_store Application.compile_env(
                    :wiki,
                    :document_store,
                    Wiki.DocumentStore.GenServerImpl
                  )

  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: change(%Document{}))}
  end

  def handle_event("validate", %{"document" => document}, socket) do
    changeset =
      %Document{}
      |> Document.changeset(document)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"document" => %{"title" => title, "content" => content}}, socket) do
    with {:ok, %{id: document_id}} <- @document_store.create(title: title, content: content) do
      {:noreply,
       socket
       |> put_flash(:info, "document created")
       |> push_redirect(to: Routes.document_show_path(socket, :show, document_id))}
    end
  end
end

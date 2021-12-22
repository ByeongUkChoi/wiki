defmodule WikiWeb.DocumentLive.New do
  use WikiWeb, :live_view

  import Ecto.Changeset

  alias Wiki.Documents.Document

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

  def handle_event("save", %{"document" => _document}, socket) do
    # insert db

    {:noreply,
     socket
     |> put_flash(:info, "document created")
     |> push_redirect(to: Routes.document_show_path(socket, :show, 999))}
  end
end

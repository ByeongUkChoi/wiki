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

    IO.inspect(changeset)
    {:noreply, assign(socket, changeset: changeset)}
  end
end

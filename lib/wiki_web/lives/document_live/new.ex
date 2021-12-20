defmodule WikiWeb.DocumentLive.New do
  use WikiWeb, :live_view

  alias Wiki.Documents.Document

  def mount(_params, _session, socket) do
    changeset = Ecto.Changeset.change(%Document{})
    {:ok, assign(socket, changeset: changeset)}
  end
end

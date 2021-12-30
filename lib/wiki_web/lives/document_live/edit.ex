defmodule WikiWeb.DocumentLive.Edit do
  use WikiWeb, :live_view

  alias Wiki.DocumentStore.Document

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    {:ok, assign(socket, [])}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    changeset =
      %Document{}
      |> Document.changeset(%{
        id: id,
        title: "Hello world. ##{id}",
        content: "This is wiki",
        created_at: DateTime.utc_now() |> DateTime.truncate(:second)
      })
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"document" => document}, socket) do
    changeset =
      %Document{}
      |> Document.changeset(document)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "save",
        %{"document" => _document},
        %{assigns: %{changeset: _changeset}} = socket
      ) do
    # update db

    # TODO: test
    document_id = 999

    {:noreply,
     socket
     |> put_flash(:info, "document created")
     |> push_redirect(to: Routes.document_show_path(socket, :show, document_id))}
  end
end

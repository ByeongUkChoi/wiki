defmodule WikiWeb.DocumentLive.Edit do
  use WikiWeb, :live_view

  alias Wiki.DocumentStore.Document

  @document_store Application.compile_env(
                    :wiki,
                    :document_store,
                    Wiki.DocumentStore.GenServerImpl
                  )

  def mount(_params, _session, socket) do
    # temperature = Thermostat.get_user_reading(user_id)
    {:ok, assign(socket, [])}
  end

  def handle_params(%{"project_id" => project_id, "id" => id}, _url, socket) do
    with id <- String.to_integer(id),
         {:ok, document} <- @document_store.fetch_by_id(id) do
      changeset = document |> Document.changeset(%{}) |> Map.put(:action, :update)
      {:noreply, assign(socket, document: document, changeset: changeset, project_id: project_id)}
    end
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
        %{"document" => document_params},
        %{assigns: %{document: document}} = socket
      ) do
    changed_document =
      document
      |> Document.changeset(document_params)
      |> Ecto.Changeset.apply_changes()

    with {:ok, _document} <- @document_store.update(changed_document) do
      {:noreply,
       socket
       |> put_flash(:info, "document created")
       |> push_redirect(to: Routes.document_show_path(socket, :show, changed_document.id))}
    end
  end
end

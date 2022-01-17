defmodule WikiWeb.DocumentLive.New do
  use WikiWeb, :live_view

  import Ecto.Changeset

  alias Wiki.DocumentStore.Document

  @document_store Application.compile_env(
                    :wiki,
                    :document_store,
                    Wiki.DocumentStore.GenServerImpl
                  )

  def mount(%{"project_id" => project_id}, _session, socket) do
    # TODO: parse project_id plugin
    {:ok, assign(socket, changeset: change(%Document{}), project_id: project_id)}
  end

  def handle_event(
        "validate",
        %{"document" => document},
        %{assigns: %{project_id: project_id}} = socket
      ) do
    attrs = document |> Map.put("project_id", String.to_integer(project_id))

    changeset =
      %Document{}
      |> Document.changeset(attrs)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"document" => %{"title" => title, "content" => content}}, socket) do
    # TODO:
    with {:ok, %{id: document_id}} <- @document_store.create(title: title, content: content) do
      {:noreply,
       socket
       |> put_flash(:info, "document created")
       |> push_redirect(to: Routes.document_show_path(socket, :show, document_id))}
    end
  end
end

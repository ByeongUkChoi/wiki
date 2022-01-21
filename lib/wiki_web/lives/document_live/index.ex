defmodule WikiWeb.DocumentLive.Index do
  use WikiWeb, :live_view

  @document_store Application.compile_env(
                    :wiki,
                    :document_store,
                    Wiki.DocumentStore.GenServerImpl
                  )

  @first_page 1
  @page_size 5

  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end

  def handle_params(%{"project_id" => project_id} = params, _url, socket) do
    [page: page, per_page: per_page] = parse_pageable(params)
    items = @document_store.fetch_all(page_num: page, per_page: per_page)
    total_count = @document_store.get_total_count()

    {:noreply,
     assign(socket,
       items: items,
       page: page,
       per_page: per_page,
       total_count: total_count,
       project_id: project_id
     )}
  end

  defp parse_pageable(params) do
    page = params |> Map.get("page", "#{@first_page}") |> String.to_integer()
    per_page = params |> Map.get("per_page", "#{@page_size}") |> String.to_integer()
    [page: page, per_page: per_page]
  end

  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end
end

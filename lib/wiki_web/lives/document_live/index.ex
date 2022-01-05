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

  def handle_params(params, _url, socket) do
    [page: page, per_page: per_page] = parse_pageable(params)
    items = @document_store.fetch_all(page_num: page, per_page: per_page)
    total_count = @document_store.get_total_count()

    {:noreply,
     assign(socket, items: items, page: page, per_page: per_page, total_count: total_count)}
  end

  defp parse_pageable(params) do
    page = params |> Map.get("page", "#{@first_page}") |> String.to_integer()
    per_page = params |> Map.get("per_page", "#{@page_size}") |> String.to_integer()
    [page: page, per_page: per_page]
  end

  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end

  defp test_items(page, per_page) do
    titles = ["Hello", "World", "Good", "Starcraft", "Happy", "Show me the money", "Hell", "TIL"]
    authors = ["Tom", "James", "Mike", "Kim", "Lee", "Ali", "King"]
    random_title = fn titles -> Enum.random(titles) end
    random_author = fn authors -> Enum.random(authors) end

    random_time = fn ->
      DateTime.utc_now() |> DateTime.add(Enum.random(-1..-9)) |> DateTime.truncate(:second)
    end

    items =
      Enum.map(1..27, fn i ->
        %{
          id: i,
          title: random_title.(titles),
          author_name: random_author.(authors),
          created_at: random_time.()
        }
      end)

    sub_items = items |> Enum.slice((page - 1) * per_page, per_page)

    [items: sub_items, total_count: length(items)]
  end
end

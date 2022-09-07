defmodule Wiki.PageStore.PostgreImpl do
  @moduledoc false

  alias Wiki.Repo
  alias Wiki.PageStore.{Page, PageIndex}

  import Ecto.{Query, Changeset}

  @behaviour Wiki.PageStore

  @impl true
  def fetch_by_id(id) do
    Repo.get(Page, id)
    |> case do
      nil -> {:error, :not_found}
      page -> {:ok, page}
    end
  end

  @impl true
  def fetch_all(parent_id: parent_id, page_num: page_num, per_page: per_page) do
    from(p in Page,
      select: %PageIndex{id: p.id, title: p.title, parent_id: p.parent_id},
      limit: ^per_page,
      offset: ^((page_num - 1) * per_page)
    )
    |> then(fn query ->
      cond do
        is_nil(parent_id) -> query |> where([p], is_nil(p.parent_id))
        true -> query |> where([p], p.parent_id == ^parent_id)
      end
    end)
    |> Repo.all()
    |> append_has_child()
  end

  @impl true
  def fetch_all(page_num: page_num, per_page: per_page) do
    from(p in Page, limit: ^per_page, offset: ^((page_num - 1) * per_page))
    |> Repo.all()
    |> append_has_child()
  end

  defp append_has_child(page_indexes) do
    page_ids = Enum.map(page_indexes, & &1.id)

    page_ids_has_child =
      from(p in Page,
        select: p.parent_id,
        where: p.parent_id in ^page_ids,
        group_by: p.parent_id
      )
      |> Repo.all()
      |> MapSet.new()

    has_child = fn page_id -> MapSet.member?(page_ids_has_child, page_id) end

    page_indexes |> Enum.map(&Map.put(&1, :has_child, has_child.(&1.id)))
  end

  @impl true
  def get_total_count() do
    Repo.aggregate(Page, :count)
  end

  @impl true
  def create(title: title, content: content, parent_id: parent_id) do
    Repo.insert(%Page{title: title, content: content, parent_id: parent_id})
    |> case do
      {:ok, page} -> {:ok, page}
      {:error, _changeset} -> {:ok, :failed_create}
    end
  end

  @impl true
  def update(id, title: title, content: content) do
    Page
    |> Repo.get(id)
    |> change(title: title, content: content)
    |> Repo.update()
    |> case do
      {:ok, page} -> {:ok, page}
      {:error, _changeset} -> {:ok, :failed_update}
    end
  end

  @impl true
  def delete_by_id(id) do
    %Page{id: id}
    |> Repo.delete()
    |> case do
      {:ok, _struct} -> :ok
      {:error, _} -> :not_found
    end
  end
end

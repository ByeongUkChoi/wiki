defmodule Wiki.PageStore.PostgreImpl do
  @moduledoc false

  alias Wiki.Repo
  alias Wiki.PageStore.Page

  import Ecto.Query

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

    from(p in Page, where: p.parent_id == ^parent_id, limit: ^per_page, offset: ^((page_num - 1) * per_page))
    |> Repo.all()
  end

  @impl true
  def fetch_all(page_num: page_num, per_page: per_page) do
    from(p in Page, limit: ^per_page, offset: ^((page_num - 1) * per_page))
    |> Repo.all()
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
end

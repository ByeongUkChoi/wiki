defmodule Wiki.PageStore.PostgreImpl do
  @moduledoc false

  alias Wiki.Repo
  alias Wiki.PageStore.Page

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
  def get_total_count() do
    Repo.aggregate(Page, :count)
  end
end

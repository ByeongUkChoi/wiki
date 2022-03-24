defmodule Wiki.PageStore do
  @moduledoc false

  alias Wiki.PageStore.{Page, PageIndex}

  @type parent_id :: Page.id()
  @type page_num :: integer()
  @type per_page :: integer()

  @callback fetch_by_id(Page.id()) :: {:ok, Page.t()} | {:error, :not_found}
  @callback fetch_all(parent_id: parent_id, page_num: page_num, per_page: per_page) :: list(PageIndex.t())
  @callback fetch_all(page_num: page_num, per_page: per_page) :: list(Page.t())
  @callback get_total_count() :: integer()

  @callback create(title: String.t(), content: String.t(), parent_id: Page.id()) ::
              {:ok, Page.t()} | {:error, :failed_create}
  @callback update(Page.t()) :: {:ok, Page.t()} | {:error, :failed_update}
  @callback delete_by_id(Page.id()) :: :ok | :not_found
end

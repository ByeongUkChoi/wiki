defmodule Wiki.DocumentStore do
  @moduledoc false

  alias Wiki.DocumentStore.Document

  @type page_num :: integer()
  @type per_page :: integer()

  @callback fetch_by_id(Document.id()) :: {:ok, Document.t()} | {:error, :not_found}
  @callback fetchAll(page_num: page_num, per_page: per_page) :: list(Document.t())
  @callback create(title: String.t(), content: String.t()) ::
              {:ok, Document.t()} | {:error, :failed_insert}
  @callback update(Document.t()) :: {:ok, Document.t()} | {:error, any()}
  @callback delete_by_id(Document.id()) :: :ok | :not_found
end

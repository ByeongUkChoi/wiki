defmodule Wiki.SpaceStore do
  @moduledoc false

  alias Wiki.SpaceStore.Space

  @type page_num :: integer()
  @type per_page :: integer()

  @callback fetch_by_id(Space.id()) :: {:ok, Space.t()} | {:error, :not_found}
  @callback fetch_all(page_num: page_num, per_page: per_page) :: list(Space.t())
  @callback get_total_count() :: integer()
  @callback create(name: String.t()) :: {:ok, Space.t()} | {:error, :failed_create}
  @callback update(Space.t()) :: {:ok, String.t()} | {:error, :failed_update}
  @callback delete_by_id(Space.id()) :: :ok | :not_found
end
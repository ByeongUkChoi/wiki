defmodule Wiki.PageStore.Page do
  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          content: String.t(),
          parent_id: integer() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  defstruct [:id, :title, :content, :parent_id, :inserted_at, :updated_at]
end

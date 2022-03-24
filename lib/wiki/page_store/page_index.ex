defmodule Wiki.PageStore.PageIndex do
  defstruct [:id, :title, :content, :parent_id, :inserted_at, :updated_at]

  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          content: String.t(),
          parent_id: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
end

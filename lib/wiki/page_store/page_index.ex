defmodule Wiki.PageStore.PageIndex do
  defstruct [:id, :title, :parent_id, :has_child, :inserted_at, :updated_at]

  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          parent_id: integer(),
          has_child: boolean(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
end

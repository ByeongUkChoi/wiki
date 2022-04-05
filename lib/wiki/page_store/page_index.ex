defmodule Wiki.PageStore.PageIndex do
  defstruct [:id, :title, :parent_id, :has_child, :children, :inserted_at, :updated_at]

  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          parent_id: integer(),
          has_child: boolean(),
          children: list(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
end

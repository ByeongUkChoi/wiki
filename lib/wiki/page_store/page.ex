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

  def changeset(page, attr) do
    attr
    |> Map.take([:title, :content, :parent_id, :updated_at])
    |> Enum.reduce(page, fn {k, v}, acc ->
      Map.put(acc, k, v)
    end)
  end
end

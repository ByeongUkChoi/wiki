defmodule Wiki.DocumentStore.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id,
          title: String.t(),
          content: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "documents" do
    field :title, :string
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
    |> validate_length(:title, max: 255)
  end
end

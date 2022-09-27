defmodule Wiki.PageStore.Page do
  use Ecto.Schema
  import Ecto.Changeset

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id,
          title: String.t(),
          content: String.t(),
          parent_id: id,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "pages" do
    field :title, :string
    field :content, :string
    field :parent_id, :integer

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :content, :parent_id])
    |> validate_required([:title, :content, :parent_id])
    |> validate_length(:title, max: 255)
  end

  # defimpl Mongo.Encoder do
  #   def encode(%{id: id, title: title, content: content, parent_id: parent_id}) do
  #     %{
  #       _id: id,
  #       title: title,
  #       content: content,
  #       parent_id: parent_id,
  #       custom_encoded: true
  #     }
  #   end
  # end
end

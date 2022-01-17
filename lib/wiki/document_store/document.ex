defmodule Wiki.DocumentStore.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wiki.ProjectStore.Project

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id,
          title: String.t(),
          content: String.t(),
          project_id: Project.id(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "documents" do
    field :title, :string
    field :content, :string
    field :project_id, :integer

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :content, :project_id])
    |> validate_required([:title, :content, :project_id])
    |> validate_length(:title, max: 255)
  end
end

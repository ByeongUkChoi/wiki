defmodule Wiki.ProjectStore.Project do
  use Ecto.Schema

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id,
          name: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "projects" do
    field :name, :string

    timestamps()
  end
end

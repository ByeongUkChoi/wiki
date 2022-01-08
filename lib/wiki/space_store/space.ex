defmodule Wiki.SpaceStore.Space do
  use Ecto.Schema

  @type id :: integer()
  @type t :: %__MODULE__{
          id: id,
          name: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "spaces" do
    field :name, :string

    timestamps()
  end
end

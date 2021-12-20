defmodule Wiki.Documents.Document do
  use Ecto.Schema

  schema "documents" do
    field :title, :string
    field :content, :string

    timestamps()
  end
end

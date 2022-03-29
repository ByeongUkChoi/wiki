defmodule Wiki.Repo.Migrations.AddPageTable do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string, null: false
      add :content, :string
      add :parent_id, :integer

      timestamps()
    end
  end
end

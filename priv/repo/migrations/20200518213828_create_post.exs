defmodule RemoteSocial.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :string
      add :link, :string
      add :author_id, references(:members, type: :binary_id)
      add :company_id, references(:company, type: :binary_id)
      timestamps()
    end

  end
end

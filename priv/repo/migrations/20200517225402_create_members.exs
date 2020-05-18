defmodule RemoteSocial.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :company_id, references(:company, type: :binary_id)
      timestamps()
    end

    create unique_index(:members, [:email])
  end
end

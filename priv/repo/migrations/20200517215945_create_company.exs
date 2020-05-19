defmodule RemoteSocial.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:company, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :tag, :string
      add :email, :string
      add :password_hash, :string
      timestamps()
    end

    create unique_index(:company, [:name])
    create unique_index(:company, [:tag])
    create unique_index(:company, [:email])
  end
end

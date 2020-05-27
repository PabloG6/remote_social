defmodule RemoteSocial.Repo.Migrations.CreateListing do
  use Ecto.Migration

  def change do
    create table(:listing, primary_key: false) do
      add :id, :binary_id, primary_key: true

      timestamps()
    end

  end
end

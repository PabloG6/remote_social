defmodule RemoteSocial.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :string
      add :sender_id, references(:members, type: :binary_id)
      add :recipient_id, references(:members, type: :binary_id)
      timestamps()
    end

  end
end

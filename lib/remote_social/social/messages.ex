defmodule RemoteSocial.Social.Messages do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemoteSocial.Account
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  schema "message" do
    field :text, :string
    belongs_to :sender, Account.Members
    belongs_to :recipient, Account.Members

    timestamps()
  end

  @doc false
  def changeset(messages, attrs) do
    messages
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end

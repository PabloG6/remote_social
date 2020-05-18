defmodule RemoteSocial.Social.Posts do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemoteSocial.Account
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  schema "post" do
    field :link, :string
    field :text, :string
    belongs_to :author, Account.Members
    timestamps()
  end

  @doc false
  def changeset(posts, attrs) do
    posts
    |> cast(attrs, [:text, :link])
    |> validate_required([:text, :link])
  end
end

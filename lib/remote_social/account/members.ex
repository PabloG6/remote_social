defmodule RemoteSocial.Account.Members do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemoteSocial
  alias RemoteSocial.Org
  alias RemoteSocial.Account.Members
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "members" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    belongs_to :company, Org.Company

    timestamps()
  end

  @doc false
  def changeset(members, attrs) do
    members
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> put_password_hash()
    |> unique_constraint(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

  def attach_company_changeset(%Members{} = members, %Org.Company{} = company) do
    members
    |> Ecto.Changeset.change()
    |> put_assoc(:company, company)
  end
end

defmodule RemoteSocial.Org.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemoteSocial.{Accounts.Members, RemoteSocial.Org.Company}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "company" do
    field :company_name, :string
    field :company_tag, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    has_many :members, Accounts.Members
    timestamps()
  end


  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:company_name, :company_tag, :email, :password])
    |> validate_required([:company_name, :company_tag, :email, :password])
    |> put_password_hash()
    |> unique_constraint(:company_name)
    |> unique_constraint(:company_tag)
    |> unique_constraint(:email)
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end



end

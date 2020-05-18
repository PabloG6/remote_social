defmodule RemoteSocial.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias RemoteSocial.Repo
  alias RemoteSocial.Org
  alias RemoteSocial.Account.Members

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Members{}, ...]

  """
  def list_members do
    Repo.all(Members)
  end

  @doc """
  Gets a single members.

  Raises `Ecto.NoResultsError` if the Members does not exist.

  ## Examples

      iex> get_members!(123)
      %Members{}

      iex> get_members!(456)
      ** (Ecto.NoResultsError)

  """
  def get_members!(id), do: Repo.get!(Members, id)

  def get_members(id) do
    with %Members{} = member <- Repo.get(Members, id) do
      {:ok, member}
    else
      nil ->
        {:error, :member_not_found}
    end
  end

  def get_members_by(params) do
    with %Members{} = members <- Repo.get_by(Members, params) do
      {:ok, members}
    else
      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Creates a members.

  ## Examples

      iex> create_members(%{field: value})
      {:ok, %Members{}}

      iex> create_members(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_members(attrs \\ %{}) do
    %Members{}
    |> Members.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a members.

  ## Examples

      iex> update_members(members, %{field: new_value})
      {:ok, %Members{}}

      iex> update_members(members, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_members(%Members{} = members, attrs) do
    members
    |> Members.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a members.

  ## Examples

      iex> delete_members(members)
      {:ok, %Members{}}

      iex> delete_members(members)
      {:error, %Ecto.Changeset{}}

  """
  def delete_members(%Members{} = members) do
    Repo.delete(members)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking members changes.

  ## Examples

      iex> change_members(members)
      %Ecto.Changeset{data: %Members{}}

  """

  def attach_company(%Org.Company{} = company, %Members{} = member) do
    Members.attach_company_changeset(member, company)
    |> Repo.insert()
  end

  def change_members(%Members{} = members, attrs \\ %{}) do
    Members.changeset(members, attrs)
  end

  def authenticate_members(%Members{} = members) do
    if Bcrypt.verify_pass(members.password, members.password_hash) do
      {:ok, members}
    else
      {:error, :invalid_credentials}
    end
  end
end

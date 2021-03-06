defmodule RemoteSocial.Org do
  @moduledoc """
  The Org context.
  """

  import Ecto.Query, warn: false
  alias RemoteSocial.Repo
  alias RemoteSocial.Account
  alias RemoteSocial.Org.Company

  @doc """
  Returns the list of company.

  ## Examples

      iex> list_company()
      [%Company{}, ...]

  """
  def list_company do
    Repo.all(Company)
  end

  def get_company_by(params) do
    with %Company{} = company <- Repo.get_by(Company, params) do
      {:ok, company}
    else
      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  def add_member(%Company{} = company, %Account.Members{} = member) do
    company
    |> Account.attach_company(member)
  end

  @spec authenticate_company(RemoteSocial.Org.Company.t()) ::
          {:error, :invalid_credentials} | {:ok, RemoteSocial.Org.Company.t()}
  def authenticate_company(%Company{} = company) do
    if Bcrypt.verify_pass(company.password, company.password_hash) do
      {:ok, company}
    else
      {:error, :invalid_credentials}
    end
  end
end

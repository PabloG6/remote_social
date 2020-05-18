defmodule RemoteSocial.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias RemoteSocial.Repo

  alias RemoteSocial.Social.Posts

  @doc """
  Returns the list of post.

  ## Examples

      iex> list_post()
      [%Posts{}, ...]

  """
  def list_post do
    Repo.all(Posts)
  end

  @doc """
  Gets a single posts.

  Raises `Ecto.NoResultsError` if the Posts does not exist.

  ## Examples

      iex> get_posts!(123)
      %Posts{}

      iex> get_posts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_posts!(id), do: Repo.get!(Posts, id)

  @doc """
  Creates a posts.

  ## Examples

      iex> create_posts(%{field: value})
      {:ok, %Posts{}}

      iex> create_posts(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_posts(attrs \\ %{}) do
    %Posts{}
    |> Posts.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a posts.

  ## Examples

      iex> update_posts(posts, %{field: new_value})
      {:ok, %Posts{}}

      iex> update_posts(posts, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_posts(%Posts{} = posts, attrs) do
    posts
    |> Posts.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a posts.

  ## Examples

      iex> delete_posts(posts)
      {:ok, %Posts{}}

      iex> delete_posts(posts)
      {:error, %Ecto.Changeset{}}

  """
  def delete_posts(%Posts{} = posts) do
    Repo.delete(posts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking posts changes.

  ## Examples

      iex> change_posts(posts)
      %Ecto.Changeset{data: %Posts{}}

  """
  def change_posts(%Posts{} = posts, attrs \\ %{}) do
    Posts.changeset(posts, attrs)
  end

  alias RemoteSocial.Social.Messages

  @doc """
  Returns the list of message.

  ## Examples

      iex> list_message()
      [%Messages{}, ...]

  """
  def list_message do
    Repo.all(Messages)
  end

  @doc """
  Gets a single messages.

  Raises `Ecto.NoResultsError` if the Messages does not exist.

  ## Examples

      iex> get_messages!(123)
      %Messages{}

      iex> get_messages!(456)
      ** (Ecto.NoResultsError)

  """
  def get_messages!(id), do: Repo.get!(Messages, id)

  @doc """
  Creates a messages.

  ## Examples

      iex> create_messages(%{field: value})
      {:ok, %Messages{}}

      iex> create_messages(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_messages(attrs \\ %{}) do
    %Messages{}
    |> Messages.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a messages.

  ## Examples

      iex> update_messages(messages, %{field: new_value})
      {:ok, %Messages{}}

      iex> update_messages(messages, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_messages(%Messages{} = messages, attrs) do
    messages
    |> Messages.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a messages.

  ## Examples

      iex> delete_messages(messages)
      {:ok, %Messages{}}

      iex> delete_messages(messages)
      {:error, %Ecto.Changeset{}}

  """
  def delete_messages(%Messages{} = messages) do
    Repo.delete(messages)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking messages changes.

  ## Examples

      iex> change_messages(messages)
      %Ecto.Changeset{data: %Messages{}}

  """
  def change_messages(%Messages{} = messages, attrs \\ %{}) do
    Messages.changeset(messages, attrs)
  end
end

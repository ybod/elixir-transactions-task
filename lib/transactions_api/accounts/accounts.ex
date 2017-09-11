defmodule Transactions.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Transactions.Repo

  alias Transactions.Accounts.User

  @doc """
  Returns the list of active users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_active_users do
    from(u in User, where: not u.is_deleted)
    |> Repo.all()
  end

  @doc """
  Gets a single user if user is active or returns :error if active user is not found.

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      {:error, :no_user_found}

  """
  def get_active_user(id) do 
    q = from(u in User, where: u.id == ^id and not u.is_deleted)

    case  Repo.one(q) do
      user = %User{} -> {:ok, user}
      nil -> {:error, :no_user_found}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    user
    |> Ecto.Changeset.change(is_deleted: true)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end

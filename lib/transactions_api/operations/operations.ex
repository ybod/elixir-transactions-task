defmodule Transactions.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias Transactions.Repo

  alias Transactions.Operations.Type

  @doc """
  Returns the list of types.

  ## Examples

      iex> list_types()
      [%Type{}, ...]

  """
  def list_types do
    Repo.all(Type)
  end

  @doc """
  Gets a single type.

  Raises `Ecto.NoResultsError` if the Type does not exist.

  ## Examples

      iex> get_type!(123)
      %Type{}

      iex> get_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type!(id), do: Repo.get!(Type, id)

  @doc """
  Creates a type.

  ## Examples

      iex> create_type(%{field: value})
      {:ok, %Type{}}

      iex> create_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type(attrs \\ %{}) do
    %Type{}
    |> Type.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type.

  ## Examples

      iex> update_type(type, %{field: new_value})
      {:ok, %Type{}}

      iex> update_type(type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type_description(%Type{} = type, attrs) do
    type
    |> Type.changeset_update(attrs)
    |> Repo.update()
  end

  alias Transactions.Operations.Operation

  @doc """
  Returns the list of operations associated with the provided user.

  ## Examples

      iex> list_user_operations(f8bbf5f0-d042-40dd-bdda-019e5f9a658a)
      [%Operation{}, ...]

  """
  def list_user_operations(user) do
    Repo.preload(user, operations: from(o in Operation, order_by: o.id, preload: [:type]))
  end

  @doc """
  Returns the list of operations of the given type (id) associated with the provided user.

  ## Examples

      iex> list_user_operations(f8bbf5f0-d042-40dd-bdda-019e5f9a658a. 12)
      [%Operation{}, ...]

  """  
  def list_user_operations(user, type_id) do
    q = 
        from o in Operation,
        order_by: o.id,
        join: type in assoc(o, :type),
        where: type.id == ^type_id,
        preload: [:type]

    Repo.preload(user, operations: q)
  end

  @doc """
  Gets a single operation.

  Raises `Ecto.NoResultsError` if the Operation does not exist.

  ## Examples

      iex> get_operation!(123)
      %Operation{}

      iex> get_operation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operation!(id) do 
    from(o in Operation, where: o.id == ^id, preload: [:user, :type])
    |> Repo.one!
  end

  @doc """
  Creates a operation.

  ## Examples

      iex> create_operation(%{field: value})
      {:ok, %Operation{}}

      iex> create_operation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_operation(attrs \\ %{}) do
    %Operation{}
    |> Operation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the total sum of all operations amount associated with the provided user by id.

  ## Examples

      iex> total(f8bbf5f0-d042-40dd-bdda-019e5f9a658a)
      10.00

  """
  def total(user_id) do
    from(o in Operation, where: o.user_id == ^user_id)
    |> Repo.aggregate(:sum, :amount)
  end

  
  @doc """
  Returns the total sum of all operations amount of the provided type associated with the provided user by id's.

  ## Examples

      iex> total(f8bbf5f0-d042-40dd-bdda-019e5f9a658a, 12)
      5.00

  """
  def total(user_id, type_id) do
    q = 
        from o in Operation,
        join: type in assoc(o, :type),
        where: o.user_id == ^user_id and type.id == ^type_id

    Repo.aggregate(q, :sum, :amount)
  end
end

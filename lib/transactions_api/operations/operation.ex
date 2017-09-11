defmodule Transactions.Operations.Operation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Transactions.Operations.Operation
  alias Transactions.Operations.Type
  alias Transactions.Accounts.User


  schema "operations" do
    field :amount, :float
    field :description, :string
    
    belongs_to :type, Type
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(%Operation{} = operation, attrs) do
    operation
    |> cast(attrs, [:amount, :description, :user_id, :type_id])
    |> validate_required([:amount, :description, :user_id, :type_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:type_id)
    |> validate_number(:amount,  greater_than_or_equal_to: -10_000.00, less_than_or_equal_to: 10_000.00)
    |> validate_length(:description, max: 255)
  end
end

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
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(%Operation{} = operation, attrs) do
    operation
    |> cast(attrs, [:amount, :description])
    |> validate_required([:amount, :description])
  end
end

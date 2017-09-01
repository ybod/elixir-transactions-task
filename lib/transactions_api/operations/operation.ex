defmodule Transactions.Operations.Operation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Transactions.Operations.Operation


  schema "operations" do
    field :amount, :float
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(%Operation{} = operation, attrs) do
    operation
    |> cast(attrs, [:amount, :description])
    |> validate_required([:amount, :description])
  end
end

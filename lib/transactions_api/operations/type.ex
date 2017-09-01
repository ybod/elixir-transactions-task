defmodule Transactions.Operations.Type do
  use Ecto.Schema
  import Ecto.Changeset
  alias Transactions.Operations.Type
  alias Transactions.Operations.Operation


  schema "types" do
    field :description, :string
    field :type, :string
    
    has_many :operations, Operation
    timestamps()
  end

  @doc false
  def changeset(%Type{} = type, attrs) do
    type
    |> cast(attrs, [:type, :description])
    |> validate_required([:type, :description])
  end
end

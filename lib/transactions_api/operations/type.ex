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
    |> validate_length(:type, max: 50)
    |> validate_length(:description, max: 255)
  end

  @doc false
  def changeset_update(%Type{} = type, attrs) do
    type
    |> cast(attrs, [:description])
    |> validate_required([:description])
    |> validate_length(:description, max: 255)
  end
end

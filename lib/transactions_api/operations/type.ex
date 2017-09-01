defmodule Transactions.Operations.Type do
  use Ecto.Schema
  import Ecto.Changeset
  alias Transactions.Operations.Type


  schema "types" do
    field :description, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%Type{} = type, attrs) do
    type
    |> cast(attrs, [:type, :description])
    |> validate_required([:type, :description])
  end
end

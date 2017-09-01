defmodule Transactions.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Transactions.Accounts.User
  alias Transactions.Operations.Operation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :age, :integer
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :is_deleted, :boolean, default: false

    has_many :operations, Operation
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :age, :email])
    |> validate_required([:first_name, :last_name, :age, :email])
  end
end

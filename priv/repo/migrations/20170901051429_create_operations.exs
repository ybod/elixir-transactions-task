defmodule Transactions.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations) do
      add :amount, :float
      add :description, :string

      timestamps()
    end

  end
end

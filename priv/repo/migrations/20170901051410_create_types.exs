defmodule Transactions.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :type, :string
      add :description, :string

      timestamps()
    end

  end
end

defmodule Transactions.Repo.Migrations.UpdateOperations do
  use Ecto.Migration

  def change do
    alter table(:operations) do
      add :type_id, references(:types), null: false
      add :user_id, references(:users, type: :uuid), null: false
    end
  end
end

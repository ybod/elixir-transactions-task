defmodule Transactions.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_deleted, :boolean, default: false
    end
  end
end

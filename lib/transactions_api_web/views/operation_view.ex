defmodule TransactionsWeb.OperationView do
  use TransactionsWeb, :view
  alias TransactionsWeb.OperationView

  def render("index.json", %{operations: operations, total: total}) do
    %{
      data: render_many(operations, OperationView, "operation.json"),
      total: total
    }
  end

  def render("show.json", %{operation: operation}) do
    %{data: render_one(operation, OperationView, "operation.json")}
  end

  def render("operation.json", %{operation: operation}) do
    %{id: operation.id,
      amount: operation.amount,
      description: operation.description,
      type: render_one(operation.type, TransactionsWeb.TypeView, "type.json"),
      user: render_one(operation.user, TransactionsWeb.UserView, "user.json")
    }
  end
end

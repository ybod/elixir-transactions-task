defmodule TransactionsWeb.OperationView do
  use TransactionsWeb, :view
  alias TransactionsWeb.OperationView

  def render("index.json", %{operations: operations}) do
    %{data: render_many(operations, OperationView, "operation.json")}
  end

  def render("show.json", %{operation: operation}) do
    %{data: render_one(operation, OperationView, "operation.json")}
  end

  def render("operation.json", %{operation: operation}) do
    %{id: operation.id,
      amount: operation.amount,
      description: operation.description}
  end
end

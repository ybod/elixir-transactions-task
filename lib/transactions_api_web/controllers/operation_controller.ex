defmodule TransactionsWeb.OperationController do
  use TransactionsWeb, :controller

  alias Transactions.Operations
  alias Transactions.Operations.Operation

  action_fallback TransactionsWeb.FallbackController

  def index(conn, _params) do
    operations = Operations.list_operations()
    render(conn, "index.json", operations: operations)
  end

  def create(conn, %{"operation" => operation_params}) do
    with {:ok, %Operation{} = operation} <- Operations.create_operation(operation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", operation_path(conn, :show, operation))
      |> render("show.json", operation: operation)
    end
  end

  def show(conn, %{"id" => id}) do
    operation = Operations.get_operation!(id)
    render(conn, "show.json", operation: operation)
  end

  def update(conn, %{"id" => id, "operation" => operation_params}) do
    operation = Operations.get_operation!(id)

    with {:ok, %Operation{} = operation} <- Operations.update_operation(operation, operation_params) do
      render(conn, "show.json", operation: operation)
    end
  end

  def delete(conn, %{"id" => id}) do
    operation = Operations.get_operation!(id)
    with {:ok, %Operation{}} <- Operations.delete_operation(operation) do
      send_resp(conn, :no_content, "")
    end
  end
end

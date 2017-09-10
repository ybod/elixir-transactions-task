defmodule TransactionsWeb.OperationController do
  use TransactionsWeb, :controller

  alias Transactions.Operations
  alias Transactions.Operations.Operation

  action_fallback TransactionsWeb.FallbackController

  def index(conn, %{"user" => user_id}) do
    operations = Operations.list_operations(user_id)
    total = Operations.total(user_id)
    render(conn, "index.json", %{operations: operations, total: total})
  end

  def index_by_type(conn, %{"user" => user_id, "type" => type_id}) do
    operations = Operations.list_operations(user_id, type_id)
    total = Operations.total(user_id, type_id)
    render(conn, "index.json", %{operations: operations, total: total})
  end

  def create(conn, %{"operation" => operation_params, "type" => type_id, "user" => user_id}) do
    params = 
      operation_params
      |> Map.put_new("type_id", type_id)
      |> Map.put_new("user_id", user_id)

    with {:ok, %Operation{} = operation} <- Operations.create_operation(params) do
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
end

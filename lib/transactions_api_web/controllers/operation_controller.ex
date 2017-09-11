defmodule TransactionsWeb.OperationController do
  use TransactionsWeb, :controller

  alias Transactions.Operations
  alias Transactions.Operations.Operation
  alias Transactions.Accounts

  action_fallback TransactionsWeb.FallbackController

  def index(conn, %{"user" => user_id}) do
    with {:ok, user} <- Accounts.get_active_user(user_id),
      user_operations <- Operations.list_user_operations(user),
      operations_total <- Operations.total(user_id),
      do: render(conn, "index.json", %{user_operations: user_operations, operations_total: operations_total})
  end

  def index_by_type(conn, %{"user" => user_id, "type" => type_id}) do
    with {:ok, user} <- Accounts.get_active_user(user_id),
    user_operations <- Operations.list_user_operations(user, type_id),
    operations_total <- Operations.total(user_id, type_id),
    do: render(conn, "index.json", %{user_operations: user_operations, operations_total: operations_total})
  end

  def create(conn, %{"operation" => operation_params, "type" => type_id, "user" => user_id}) do
    params = 
      Enum.into(operation_params, %{"type_id" => type_id, "user_id" => user_id})

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

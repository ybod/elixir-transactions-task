defmodule TransactionsWeb.OperationControllerTest do
  use TransactionsWeb.ConnCase

  alias Transactions.Operations
  alias Transactions.Operations.Operation

  @create_attrs %{amount: 120.5, description: "some description"}
  @update_attrs %{amount: 456.7, description: "some updated description"}
  @invalid_attrs %{amount: nil, description: nil}

  def fixture(:operation) do
    {:ok, operation} = Operations.create_operation(@create_attrs)
    operation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all operations", %{conn: conn} do
      conn = get conn, operation_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create operation" do
    test "renders operation when data is valid", %{conn: conn} do
      conn = post conn, operation_path(conn, :create), operation: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, operation_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 120.5,
        "description" => "some description"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, operation_path(conn, :create), operation: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update operation" do
    setup [:create_operation]

    test "renders operation when data is valid", %{conn: conn, operation: %Operation{id: id} = operation} do
      conn = put conn, operation_path(conn, :update, operation), operation: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, operation_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 456.7,
        "description" => "some updated description"}
    end

    test "renders errors when data is invalid", %{conn: conn, operation: operation} do
      conn = put conn, operation_path(conn, :update, operation), operation: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete operation" do
    setup [:create_operation]

    test "deletes chosen operation", %{conn: conn, operation: operation} do
      conn = delete conn, operation_path(conn, :delete, operation)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, operation_path(conn, :show, operation)
      end
    end
  end

  defp create_operation(_) do
    operation = fixture(:operation)
    {:ok, operation: operation}
  end
end

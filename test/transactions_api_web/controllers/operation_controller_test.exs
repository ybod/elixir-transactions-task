defmodule TransactionsWeb.OperationControllerTest do
  use TransactionsWeb.ConnCase

  alias Transactions.Operations
  alias Transactions.Operations.Operation

  @create_attrs %{amount: 120.5, description: "some description"}
  @invalid_attrs %{amount: nil, description: nil}

  @user_attrs %{age: 22, email: "some@email.com", first_name: "SomeFirstName", last_name: "SomeLastName"}
  @type_attrs %{description: "some description", type: String.duplicate("T", 50)}

  def fixture(:operation) do
    {:ok, user} = Transactions.Accounts.create_user(@user_attrs)
    {:ok, type} = Operations.create_type(@type_attrs)
    
    operation_attr = 
      @create_attrs
      |> Enum.into(%{type_id: type.id, user_id: user.id})

    {:ok, operation} = Operations.create_operation(operation_attr)
    
    %{operation: operation, user: user, type: type}
  end

  
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all operations by user id", %{conn: conn} do
      %{user: user} = fixture(:operation) 

      conn = get conn, operation_path(conn, :index, user.id)
      [data_operation] = json_response(conn, 200)["data"]["operations"]
      total = json_response(conn, 200)["data"]["total"]
      
      assert data_operation["description"] == @create_attrs.description
      assert data_operation["amount"] == @create_attrs.amount
      assert total == @create_attrs.amount
    end

    test "returns error for deleted user id", %{conn: conn} do
      %{user: user} = fixture(:operation) 
      {:ok, _} = Transactions.Accounts.delete_user(user)

      conn = get conn, operation_path(conn, :index, user.id)
      assert %{"errors" => _} = json_response(conn, 404)
    end

    test "lists all operations by user id and type id", %{conn: conn} do
      %{user: user, type: type} = fixture(:operation) 

      conn = get conn, operation_path(conn, :index_by_type, user.id, type.id)
      [data_operation] = json_response(conn, 200)["data"]["operations"]
      total = json_response(conn, 200)["data"]["total"]

      assert data_operation["description"] == @create_attrs.description
      assert data_operation["amount"] == @create_attrs.amount
      assert total == @create_attrs.amount
    end

    test "returns error for deleted user id with correct type id", %{conn: conn} do
      %{user: user, type: type} = fixture(:operation) 
      {:ok, _} = Transactions.Accounts.delete_user(user)

      conn = get conn, operation_path(conn, :index_by_type, user.id, type.id)
      assert %{"errors" => _} = json_response(conn, 404)
    end
  end

  describe "create operation" do
    test "renders operation when data is valid", %{conn: conn} do
      {:ok, user} = Transactions.Accounts.create_user(@user_attrs)
      {:ok, type} = Operations.create_type(@type_attrs)
      
      conn = post conn, operation_path(conn, :create, user.id, type.id), operation: @create_attrs
      data_created = json_response(conn, 201)["data"]

      conn = get conn, operation_path(conn, :show, data_created["id"])
      data_shown = assert json_response(conn, 200)["data"] 

      assert data_shown["id"] == data_created["id"]
      assert data_shown["amount"] == @create_attrs.amount
      assert data_shown["description"] == @create_attrs.description
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, user} = Transactions.Accounts.create_user(@user_attrs)
      {:ok, type} = Operations.create_type(@type_attrs)
      
      conn = post conn, operation_path(conn, :create, user.id, type.id), operation: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end

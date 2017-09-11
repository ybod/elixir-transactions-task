defmodule TransactionsWeb.TypeControllerTest do
  use TransactionsWeb.ConnCase

  alias Transactions.Operations
  alias Transactions.Operations.Type

  @create_attrs %{description: "some description", type: "some type"}
  @update_attrs %{description: "some updated description", type: "some updated type"}
  @invalid_attrs %{description: nil, type: nil}

  def fixture(:type) do
    {:ok, type} = Operations.create_type(@create_attrs)
    type
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all types", %{conn: conn} do
      conn = get conn, type_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create type" do
    test "renders type when data is valid", %{conn: conn} do
      conn = post conn, type_path(conn, :create), type: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, type_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => @create_attrs.description,
        "type" => @create_attrs.type}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, type_path(conn, :create), type: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update type" do
    test "renders type when data is valid", %{conn: conn} do
      type = fixture(:type)
      id = type.id

      conn = put conn, type_path(conn, :update, type), type: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, type_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => @update_attrs.description,
        "type" => @create_attrs.type}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      type = fixture(:type)
      
      conn = put conn, type_path(conn, :update, type), type: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end

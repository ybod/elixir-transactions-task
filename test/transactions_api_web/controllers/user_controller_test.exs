defmodule TransactionsWeb.UserControllerTest do
  use TransactionsWeb.ConnCase

  alias Transactions.Accounts
  alias Transactions.Accounts.User

  @create_attrs %{age: 22, email: "some@email.com", first_name: "SomeFirstName", last_name: "SomeLastName"}
  @update_attrs %{age: 100, email: "some.updated@email.com", first_name: String.duplicate("U", 100), last_name: "SomeUpdatedLastName"}
  @invalid_attrs %{age: nil, email: nil, first_name: nil, last_name: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "age" => @create_attrs.age,
        "email" => @create_attrs.email,
        "first_name" => @create_attrs.first_name,
        "last_name" => @create_attrs.last_name}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "age" => @update_attrs.age,
        "email" => @update_attrs.email,
        "first_name" => @update_attrs.first_name,
        "last_name" => @update_attrs.last_name}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      
      conn = get conn, user_path(conn, :show, user)
      assert json_response(conn, 404)["errors"] == %{"detail" => "No active user was found with given id"}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

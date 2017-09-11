defmodule Transactions.OperationsTest do
  use Transactions.DataCase

  alias Transactions.Operations

  describe "types" do
    alias Transactions.Operations.Type

    @valid_attrs %{description: "some description", type: String.duplicate("T", 50)}
    @update_attrs %{description: String.duplicate("D", 255), type: "some updated type"}
    @invalid_attrs %{description: nil, type: nil}

    def type_fixture(attrs \\ %{}) do
      {:ok, type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_type()

      type
    end

    test "list_types/0 returns all types" do
      type = type_fixture()
      assert Operations.list_types() == [type]
    end

    test "get_type!/1 returns the type with given id" do
      type = type_fixture()
      assert Operations.get_type!(type.id) == type
    end

    test "create_type/1 with valid data creates a type" do
      assert {:ok, %Type{} = type} = Operations.create_type(@valid_attrs)
      assert type.description == @valid_attrs.description
      assert type.type == @valid_attrs.type
    end

    test "create_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_type(@invalid_attrs)
    end

    test "update_type/2 with valid data updates the type description only" do
      type = type_fixture()
      assert {:ok, type} = Operations.update_type_description(type, @update_attrs)
      assert %Type{} = type
      assert type.description == @update_attrs.description
      assert type.type == @valid_attrs.type
    end

    test "update_type/2 with invalid data returns error changeset" do
      type = type_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_type_description(type, @invalid_attrs)
      assert type == Operations.get_type!(type.id)
    end

    test "type changeset can validate incorrect parameters" do
      type = type_fixture()
      
      assert %Ecto.Changeset{valid?: false} = Type.changeset(type, %{type: nil})
      assert %Ecto.Changeset{valid?: false} = Type.changeset(type, %{type: ""})
      assert %Ecto.Changeset{valid?: false} = Type.changeset(type, %{type: String.duplicate("!", 51)})

      assert %Ecto.Changeset{valid?: false} = Type.changeset(type, %{description: nil})
      assert %Ecto.Changeset{valid?: false} = Type.changeset(type, %{description: ""})
      assert %Ecto.Changeset{valid?: false} = Type.changeset(type, %{description: String.duplicate("!", 256)})
    end

    test "type changeset_update can validate incorrect parameters" do
      type = type_fixture()
      
      assert %Ecto.Changeset{valid?: false} = Type.changeset_update(type, %{description: nil})
      assert %Ecto.Changeset{valid?: false} = Type.changeset_update(type, %{description: ""})
      assert %Ecto.Changeset{valid?: false} = Type.changeset_update(type, %{description: String.duplicate("!", 256)})
    end

    test "type changeset_update filters out type parameter" do
      type = type_fixture()

      update_changeset = Type.changeset_update(type, %{type: "some new type"})
      refute update_changeset.changes == %{type: "some new type"}
    end
  end

  describe "operations" do
    alias Transactions.Operations.Operation
    alias Transactions.Accounts

    @valid_attrs %{amount: -10_000.0, description: "d"}
    @invalid_attrs %{amount: nil, description: nil}

    @user_attrs %{age: 22, email: "some@email.com", first_name: "SomeFirstName", last_name: "SomeLastName"}
    @type_attrs %{description: "some description", type: String.duplicate("T", 50)}

    def operation_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(@user_attrs)
      {:ok, type} = Operations.create_type(@type_attrs)
     
      {:ok, operation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{type_id: type.id, user_id: user.id})
        |> Operations.create_operation()

      %{operation: operation, user: user, type: type}      
    end

    test "list_user_operations/1 returns all user operations" do
      %{operation: operation, user: user, type: type} = operation_fixture()
      user_w_operations = Operations.list_user_operations(user) 
      [user_operation] = user_w_operations.operations 

      assert user_w_operations.id == user.id
      assert user_operation.id == operation.id
      assert user_operation.type.id == type.id
    end

    test "list_user_operations/2 returns all user operations of defined type" do
      %{operation: operation, user: user, type: type} = operation_fixture()
      user_w_operations = Operations.list_user_operations(user, type.id) 
      [user_operation] = user_w_operations.operations 

      assert user_w_operations.id == user.id
      assert user_operation.id == operation.id
      assert user_operation.type.id == type.id
    end

    test "get_operation!/1 returns the operation with given id" do
      %{operation: operation, user: user, type: type} = operation_fixture()
      user_operation = Operations.get_operation!(operation.id) 

      assert user_operation.id == operation.id
      assert user_operation.user.id == user.id
      assert user_operation.type.id == type.id
    end

    test "create_operation/1 with valid data creates a operation" do
      {:ok, user} = Accounts.create_user(@user_attrs)
      {:ok, type} = Operations.create_type(@type_attrs)
      
      operation_attr = 
        @valid_attrs
        |> Enum.into(%{type_id: type.id, user_id: user.id})

      assert {:ok, %Operation{} = operation} = Operations.create_operation(operation_attr)

      assert operation.amount == @valid_attrs.amount
      assert operation.description == @valid_attrs.description
    end

    test "create_operation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_operation(@invalid_attrs)
    end

    test "user changeset can validate required parameters" do
      %{operation: operation} = operation_fixture()

      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{amount: nil})
      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{amount: ""})
      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{amount: -10_000.001})
      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{amount: 10_000.0001})
      
      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{description: nil})
      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{description: ""})
      assert %Ecto.Changeset{valid?: false} = Operation.changeset(operation, %{description:  String.duplicate("!", 256)})
    end
  end
end

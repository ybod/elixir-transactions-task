defmodule Transactions.OperationsTest do
  use Transactions.DataCase

  alias Transactions.Operations

  describe "types" do
    alias Transactions.Operations.Type

    @valid_attrs %{description: "some description", type: "some type"}
    @update_attrs %{description: "some updated description", type: "some updated type"}
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
      assert type.description == "some description"
      assert type.type == "some type"
    end

    test "create_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_type(@invalid_attrs)
    end

    test "update_type/2 with valid data updates the type" do
      type = type_fixture()
      assert {:ok, type} = Operations.update_type(type, @update_attrs)
      assert %Type{} = type
      assert type.description == "some updated description"
      assert type.type == "some updated type"
    end

    test "update_type/2 with invalid data returns error changeset" do
      type = type_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_type(type, @invalid_attrs)
      assert type == Operations.get_type!(type.id)
    end

    test "delete_type/1 deletes the type" do
      type = type_fixture()
      assert {:ok, %Type{}} = Operations.delete_type(type)
      assert_raise Ecto.NoResultsError, fn -> Operations.get_type!(type.id) end
    end

    test "change_type/1 returns a type changeset" do
      type = type_fixture()
      assert %Ecto.Changeset{} = Operations.change_type(type)
    end
  end

  describe "operations" do
    alias Transactions.Operations.Operation

    @valid_attrs %{amount: 120.5, description: "some description"}
    @update_attrs %{amount: 456.7, description: "some updated description"}
    @invalid_attrs %{amount: nil, description: nil}

    def operation_fixture(attrs \\ %{}) do
      {:ok, operation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_operation()

      operation
    end

    test "list_operations/0 returns all operations" do
      operation = operation_fixture()
      assert Operations.list_operations() == [operation]
    end

    test "get_operation!/1 returns the operation with given id" do
      operation = operation_fixture()
      assert Operations.get_operation!(operation.id) == operation
    end

    test "create_operation/1 with valid data creates a operation" do
      assert {:ok, %Operation{} = operation} = Operations.create_operation(@valid_attrs)
      assert operation.amount == 120.5
      assert operation.description == "some description"
    end

    test "create_operation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_operation(@invalid_attrs)
    end

    test "update_operation/2 with valid data updates the operation" do
      operation = operation_fixture()
      assert {:ok, operation} = Operations.update_operation(operation, @update_attrs)
      assert %Operation{} = operation
      assert operation.amount == 456.7
      assert operation.description == "some updated description"
    end

    test "update_operation/2 with invalid data returns error changeset" do
      operation = operation_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_operation(operation, @invalid_attrs)
      assert operation == Operations.get_operation!(operation.id)
    end

    test "delete_operation/1 deletes the operation" do
      operation = operation_fixture()
      assert {:ok, %Operation{}} = Operations.delete_operation(operation)
      assert_raise Ecto.NoResultsError, fn -> Operations.get_operation!(operation.id) end
    end

    test "change_operation/1 returns a operation changeset" do
      operation = operation_fixture()
      assert %Ecto.Changeset{} = Operations.change_operation(operation)
    end
  end
end

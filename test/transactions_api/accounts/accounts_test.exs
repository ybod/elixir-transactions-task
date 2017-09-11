defmodule Transactions.AccountsTest do
  use Transactions.DataCase

  alias Transactions.Accounts

  describe "users" do
    alias Transactions.Accounts.User

    @valid_attrs %{age: 22, email: "some@email.com", first_name: "SomeFirstName", last_name: "SomeLastName"}
    @update_attrs %{age: 100, email: "some.updated@email.com", first_name: String.duplicate("U", 100), last_name: "SomeUpdatedLastName"}
    @invalid_attrs %{age: nil, email: nil, first_name: nil, last_name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_active_users/0 returns active users" do
      user = user_fixture()
      assert Accounts.list_active_users() == [user]
    end

    test "list_active_users/0 do not returns deleted users" do
      user = user_fixture()
      {:ok, _} = Accounts.delete_user(user)
      assert Accounts.list_active_users() == []
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert Accounts.get_active_user(user.id) == {:error, :no_user_found}
    end

    test "get_active_user/1 returns the active user with given id" do
      user = user_fixture()
      assert {:ok, ^user} = Accounts.get_active_user(user.id)
    end

    test "get_active_user/1 do not returns deleted user with given id" do
      user = user_fixture()
      {:ok, _} = Accounts.delete_user(user)
      assert Accounts.get_active_user(user.id) == {:error, :no_user_found}
    end
    
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.age == @valid_attrs.age
      assert user.email == @valid_attrs.email
      assert user.first_name == @valid_attrs.first_name
      assert user.last_name == @valid_attrs.last_name
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.age == @update_attrs.age
      assert user.email == @update_attrs.email
      assert user.first_name == @update_attrs.first_name
      assert user.last_name == @update_attrs.last_name
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert {:ok, ^user} = Accounts.get_active_user(user.id)
    end

    test "update_user/2 can't update is_deleted user attribute" do
      user = user_fixture()
      {:ok, updated_user} = Accounts.update_user(user, %{is_deleted: true})

      refute updated_user.is_deleted == true;
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "user changeset can validate required parameters" do
      user = user_fixture()

      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{age: nil})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{first_name: nil})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{last_name: nil})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{email: nil})
    end

    test "user changeset can validate incorrect parameters" do
      user = user_fixture()
      
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{age: ""})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{age: 15})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{age: 101})
      
      long_name = String.duplicate("L", 101)
      
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{first_name: long_name})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{first_name: ""})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{last_name: long_name})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{last_name: ""})
      
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{email: "some.incorrect.email"})
      assert %Ecto.Changeset{valid?: false} = User.changeset(user, %{email: ""})
    end

    test "user changeset filters out is_deleted attribute" do
      user = user_fixture()

      deleted_changeset = User.changeset(user, %{is_deleted: true})
      refute deleted_changeset.changes == %{is_deleted: true}
    end
  end
end

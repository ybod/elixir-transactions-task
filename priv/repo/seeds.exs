# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Transactions.Repo.insert!(%Transactions.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Transactions.Repo;
alias Transactions.Accounts.User;
alias Transactions.Operations.Type;
alias Transactions.Operations.Operation;

Repo.delete_all Operation
Repo.delete_all User
Repo.delete_all Type

# Users
user_james = Repo.insert!(%User{age: 25, email: "a@b.com", first_name: "James", last_name: "Bond"})
user_yurii = Repo.insert!(%User{age: 36, email: "yurii@mail.com", first_name: "Yurii", last_name: "Bodarev"})
user_ivan = Repo.insert!(%User{age: 30, email: "ivan@zmail.com", first_name: "Ivan", last_name: "Zushko"})
Repo.insert!(%User{age: 66, email: "deleted@xmail.com", first_name: "Deleted", last_name: "User", is_deleted: true})

# Operation types
debit_operation_type = Repo.insert!(%Type{type: "debit", description: "remove an amount of money from a users's account"})
credit_operation_type = Repo.insert!(%Type{type: "credit", description: "add an amount of money to a users's account"})


# Operations
%Operation{amount: 10.0, description: "Enumeration", user: user_james, type: credit_operation_type }
|> Repo.insert!

%Operation{amount: -5.0, description: "Amazon sale", user: user_james, type: debit_operation_type }
|> Repo.insert!

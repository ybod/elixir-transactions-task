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

Repo.delete_all User

Repo.insert!(%User{age: 25, email: "a@b.com", first_name: "James", last_name: "Bond"});
Repo.insert!(%User{age: 36, email: "yurii@mail.com", first_name: "Yurii", last_name: "Bodarev"});
Repo.insert!(%User{age: 30, email: "ivan@zmail.com", first_name: "Ivan", last_name: "Zushko"});
Repo.insert!(%User{age: 66, email: "deleted@xmail.com", first_name: "Deleted", last_name: "User", is_deleted: true});
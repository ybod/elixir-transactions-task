# Elixir test project implementing simple transactions API w/Phoenix 1.3 without AUTH

To start API Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Optionally: you can seed database with `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

  * You can run test with `mix test`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

_You will need to have PostgreSQL installed with default user "postgres"/ "postgres" or update Repo configurations in `config` folder to use another user/password_

## Project description

This project implements simpe API server that allows to manage users and create different types of transcations for every user. No authentification was implemented because this is the complex task and lies beyond the scope of the small project.

Project consists of the two contexts:

  * **Accounts** is responsible for manipulations with **User** entities. Users can be listed, created, updated and _deleted_. Actually no user information is deleted from DB, user gets special **is_deleted** attribute and excluded from any related API results 
but all related information is still preserved.
  * **Operations** contains **Operation** -
 transaction of a a given **Type**. Each transaction is connected with **User** and **Type**.
  * **Type** can be created, shown, and type description can be updated. Once created - operation type can't be deleted.
  * **Operation** of particular types can be created for a given user. Once created - operations can't be not updated not deleted. In case of balance correction - You can introduce a new operation of specific type and/or description (
eg "adjustment", "refund"...)

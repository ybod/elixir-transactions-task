# Elixir test project implementing simple transactions API w/Phoenix 1.3 without AUTH

To start API Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * _Optionally: you can seed database with `mix run priv/repo/seeds.exs`_
  * Start Phoenix endpoint with `mix phx.server`

  * _You can run tests with `mix test`_

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

_You will need to have PostgreSQL installed with default user "postgres"/ "postgres" or update Repo configurations in `config` folder to use another user/password_

## Project description

This project implements simpe API server that allows to manage users and create different types of transcations for every user. No authentification was implemented because this is the complex task and lies beyond the scope of the small project.

Project consists of the two contexts:

  * **Accounts** is responsible for manipulations with **User** entities. Users can be listed, created, updated and _deleted_. Actually no user information is deleted from DB, user gets special **is_deleted** attribute and excluded from any API results but all related information is still preserved.
  * **Operations** contains **Operation** -
 transaction of a a given **Type**. Each transaction is connected with **User** and **Type**.
  * **Type** can be created, shown, and type description can be updated. Once created - operation type can't be deleted.
  * **Operation** of particular types can be created for a given user. Once created - operations can't be not updated not deleted. In case of balance correction - You can introduce a new operation of specific type and/or description (eg "adjustment", "refund"...)

## API details

Following API operations are available:

```
GET     /api/users
GET     /api/users/:id                 
POST    /api/users                     
PATCH   /api/users/:id                 
PUT     /api/users/:id                 
DELETE  /api/users/:id          
```
These operations allows to get list of all available users, show user by `id`, create user, update and delete user. You can set `is_deleted` attribute only with `DELETE` operation, update operation ignores this arttibute. _Deleted_ user is exluded from the users list, and returns error if You try to manipulate this recored by `id`.

```
GET     /api/operations/types          
GET     /api/operations/types/:id      
POST    /api/operations/types          
PATCH   /api/operations/types/:id      
PUT     /api/operations/types/:id
```
These operations allows manipulations with _transcation_ types. Once created - type can't be deleted and only type description can be udpated.

```
GET     /api/operations/all/:user      
GET     /api/operations/all/:user/:type
GET     /api/operations/:id            
POST    /api/operations/:user/:type    
```
This set of API calls allows manipulations with `operations`(transcations). You can get the list of all transactions for the user. You can list user transcations only of the particular type. And You can create a new transaction. Once created - transaction can't be nor deleted not modified.

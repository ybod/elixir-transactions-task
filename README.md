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
  * **Operation** of particular types can be created for a given user. Once created - operations can't be nor updated not deleted. In case of balance correction - You can introduce a new operation with specific type and/or description (eg "adjustment", "refund"...)

## API details

Following API operations are available:

### User
```
GET     /api/users
GET     /api/users/:id                 
POST    /api/users                     
PATCH   /api/users/:id                 
PUT     /api/users/:id                 
DELETE  /api/users/:id          
```
These operations allows to get list of all available users, show user by `id`, create user, update and delete user. You can set `is_deleted` attribute only with `DELETE` operation, update operation ignores this arttibute. _Deleted_ user is exluded from the users list, and returns error if You try to manipulate this recored by `id`.

Example of **User** JSON:
```json
		{
			"last_name": "Bond",
			"id": "2a9bc69e-2b33-4099-ab1b-11ecb25b969e",
			"first_name": "James",
			"email": "a@b.com",
			"age": 25
		}
```

### Type
```
GET     /api/operations/types          
GET     /api/operations/types/:id      
POST    /api/operations/types          
PATCH   /api/operations/types/:id      
PUT     /api/operations/types/:id
```
These operations allows manipulations with _transcation_ types. Once created - type can't be deleted and only type description can be udpated.

Example of **Type** JSON:
```json
		{
			"type": "debit",
			"id": 1,
			"description": "remove an amount of money from a users's account"
		}
```

### Operation
```
GET     /api/operations/all/:user      
GET     /api/operations/all/:user/:type
GET     /api/operations/:id            
POST    /api/operations/:user/:type    
```
This set of API calls allows manipulations with `operations`(transcations). You can get the list of all transactions for the user. You can list user transcations only of the particular type. And You can create a new transaction. Once created - transaction can't be nor deleted not modified.

Example of **Operation**s JSON:
```json
{
	"data": {
		"user": {
			"last_name": "Bond",
			"id": "2a9bc69e-2b33-4099-ab1b-11ecb25b969e",
			"first_name": "James",
			"email": "a@b.com",
			"age": 25
		},
		"total": 5.0,
		"operations": [
			{
				"type": {
					"type": "credit",
					"id": 2,
					"description": "add an amount of money to a users's account"
				},
				"id": 1,
				"description": "Enumeration",
				"date": "2017-09-11T15:51:57.547000",
				"amount": 10.0
			},
			{
				"type": {
					"type": "debit",
					"id": 1,
					"description": "remove an amount of money from a users's account"
				},
				"id": 2,
				"description": "Amazon sale",
				"date": "2017-09-11T15:51:57.565000",
				"amount": -5.0
			}
		]
	}
}
```

## API operations Examples
#### Get all users
![Get all users](http://i.piccy.info/i9/dc5a476e23eb356564cc722029e6950b/1505145709/63498/1178831/Get_Users.jpg "Get all users") 

#### Create user
![Create user](http://i.piccy.info/i9/27edf46b601d075615d132521a9b082f/1505146083/63498/1178831/Get_Users.jpg "Create user") 

#### Trying to get deleted user
![Trying to get deleted user](http://i.piccy.info/i9/6d2a7f504fa27cbef7361c8af419932f/1505146140/36073/1178831/Get_Deleted_User.jpg "Trying to get deleted user") 

#### Get operation types
![Get operation types](http://i.piccy.info/i9/607fb6ad2670b50c92a8d042b3f7dae7/1505146444/45421/1178831/Get_Types.jpg "Get operation types") 

#### Create new operation type
![Create new operation type](http://i.piccy.info/i9/3a4f9c28afb0d83609fae719702e28a7/1505146503/39625/1178831/Create_type.jpg "Create new operation type") 

#### Get operations by User Id
![Get operations by User Id](http://i.piccy.info/i9/c82bbb734aade08eee7f6b50550f5932/1505146845/89317/1178831/Get_operations.jpg "Get operations by User Id") 

#### Get operations by User ans Type Id's
![Get operations by User ans Type Id's](http://i.piccy.info/i9/ecd5dbfee5ce4f7268348f78775c444a/1505146898/71754/1178831/Get_operation_by_type.jpg "Get operations by User ans Type Id's") 


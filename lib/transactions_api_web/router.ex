defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionsWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    
    scope "/operations" do
      resources "/types", TypeController, only: [:index, :create, :show, :update]
      
      get "/all/:user", OperationController, :index
      get "/all/:user/:type", OperationController, :index_by_type
      get "/:id", OperationController, :show
      post "/:user/:type", OperationController, :create
    end
  end
end

defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionsWeb do
    resources "/users", UserController, except: [:new, :edit]
    
    scope "/operations", TransactionsWeb do
      resources "/types", TypeController, only: [:index, :create, :show]
      resources "/operations", OperationController, only: [:index, :create, :show]
    end
    
    pipe_through :api
  end
end

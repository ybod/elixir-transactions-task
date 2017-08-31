defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionsWeb do
    resources "/users", UserController, except: [:new, :edit]
    
    pipe_through :api
  end
end

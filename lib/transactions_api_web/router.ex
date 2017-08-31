defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionsWeb do
    pipe_through :api
  end
end

defmodule TransactionsWeb.UserController do
  use TransactionsWeb, :controller

  alias Transactions.Accounts
  alias Transactions.Accounts.User

  action_fallback TransactionsWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_active_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- get_active_user(id) do
      render(conn, "show.json", user: user)
    end      
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- get_active_user(id),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params), 
      do:  render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- get_active_user(id),    
         {:ok, %User{}} <- Accounts.delete_user(user), 
         do: send_resp(conn, :no_content, "")
  end

  defp get_active_user(id) do
    case Accounts.get_active_user(id) do
      user = %User{} -> {:ok, user}
      nil -> {:error, :no_user_found}
    end
  end
end

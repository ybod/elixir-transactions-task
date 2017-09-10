defmodule TransactionsWeb.TypeController do
  use TransactionsWeb, :controller

  alias Transactions.Operations
  alias Transactions.Operations.Type

  action_fallback TransactionsWeb.FallbackController

  def index(conn, _params) do
    types = Operations.list_types()
    render(conn, "index.json", types: types)
  end

  def create(conn, %{"type" => type_params}) do
    with {:ok, %Type{} = type} <- Operations.create_type(type_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", type_path(conn, :show, type))
      |> render("show.json", type: type)
    end
  end

  def show(conn, %{"id" => id}) do
    type = Operations.get_type!(id)
    render(conn, "show.json", type: type)
  end

  def update(conn, %{"id" => id, "type" => type_params}) do
    type = Operations.get_type!(id)

    with {:ok, %Type{} = type} <- Operations.update_type_description(type, type_params) do
      render(conn, "show.json", type: type)
    end
  end
end

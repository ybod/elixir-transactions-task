defmodule TransactionsWeb.UserErrorView do
  use TransactionsWeb, :view

  def render("no_user_found.json", _assigns) do
    %{errors: %{detail: "No active user was found with given id"}}
  end
end
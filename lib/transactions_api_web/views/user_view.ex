defmodule TransactionsWeb.UserView do
  use TransactionsWeb, :view
  alias TransactionsWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    if not user.is_deleted do
      %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      age: user.age,
      email: user.email
      }
    end
  end
end

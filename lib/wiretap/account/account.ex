defmodule Wiretap.Account do
  alias Wiretap.Repo
  alias Wiretap.Account.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
  end

  def get_user(id) do
    Repo.get!(User, id)
  end

end

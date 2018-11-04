defmodule WiretapWeb.Resolvers.User do
  alias Wiretap.Account.User
  alias Wiretap.Repo

  def resolve_user(_, _, %{context: context}) do
    %{current_user: user} = context
    {:ok, user}
  end

  def user_contacts(%User{} = user, _, _) do
    user = Repo.preload(user, :contacts)
    {:ok, user.contacts}
  end

  def user_feed(%User{} = user, _, _) do
    user = Repo.preload(user, :feed)
    {:ok, user.feed}
  end

  def user_calls(%User{} = user, _, _) do
    user = Repo.preload(user, :calls)
    {:ok, user.calls}
  end

end

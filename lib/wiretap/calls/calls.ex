defmodule Wiretap.Calls do
  alias Wiretap.Repo
  alias Ecto.Changeset
  alias Wiretap.Calls.Call

  def create_call(user, contact) do
    %Call{}
    |> Call.changeset()
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:contact, contact)
    |> Repo.insert
  end

  def get_call(id) do
    Repo.get!(Call, id)
  end

end

defmodule Wiretap.Contacts do
  alias Ecto.Changeset

  alias Wiretap.Repo
  alias Wiretap.Contacts.Contact

  def create_contact(attrs \\ %{}, user) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert
  end

  def get_contact(id) do
    Repo.get!(Contact, id)
  end
end

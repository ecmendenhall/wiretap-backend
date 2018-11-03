defmodule WiretapWeb.Resolvers.Contact do
  alias Wiretap.Contacts
  alias Wiretap.Repo

  def create_contact(_, %{input: params}, _) do
    user = Wiretap.Account.get_last_user()
    {:ok, contact} = Contacts.create_contact(params, user)
    {:ok, contact}
  end

end

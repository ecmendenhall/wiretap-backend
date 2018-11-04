defmodule WiretapWeb.Resolvers.Contact do
  alias Wiretap.Contacts
  alias Wiretap.Repo

  def create_contact(_, %{input: params}, %{context: context}) do
    %{current_user: user} = context
    {:ok, contact} = Contacts.create_contact(params, user)
    {:ok, contact}
  end

end

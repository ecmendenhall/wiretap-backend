defmodule WiretapWeb.Resolvers.Call do
  alias Wiretap.Calls.Call
  alias Wiretap.Repo

  def call_user(%Call{} = call, _, _) do
    call = Repo.preload(call, :user)
    {:ok, call.user}
  end

  def call_contact(%Call{} = call, _, _) do
    call = Repo.preload(call, :contact)
    {:ok, call.contact}
  end

  def start_call(_, %{input: params}, _) do
    %{ contact_id: contact_id } = params
    user = Wiretap.Account.get_last_user()
    contact = Wiretap.Contacts.get_contact(contact_id)
    {:ok, call} = Wiretap.Calls.create_call(user, contact)
    Wiretap.Calls.start(call)
    {:ok, call}
  end

end

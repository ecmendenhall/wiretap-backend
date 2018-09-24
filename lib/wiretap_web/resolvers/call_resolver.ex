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

end

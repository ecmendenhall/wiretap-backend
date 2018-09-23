defmodule Wiretap.Calls do
  alias Wiretap.Repo
  alias Ecto.Changeset
  alias Wiretap.Calls.Call
  alias Twilio

  def create_call(user, contact) do
    %Call{}
    |> Call.changeset()
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:contact, contact)
    |> Repo.insert
  end

  def get_call(id) do
    Call
    |> Repo.get!(id)
    |> Repo.preload([:user, :contact])
  end

  def start(call) do
    Twilio.call!(%{
      to: call.user.phone_number,
      url: "https://twilio:test-password@ce055246.ngrok.io/webhooks/call/#{call.id}"
    })
  end


end

defmodule Wiretap.Calls do
  alias Wiretap.Repo
  alias Ecto.Changeset
  alias Wiretap.Calls.Call
  alias Twilio

  def create_call(user, contact) do
    %Call{}
    |> Call.changeset(%{})
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:contact, contact)
    |> Repo.insert
  end

  def update_call(%Call{} = call, attrs) do
    call
    |> Call.changeset(attrs)
    |> Repo.update
  end

  def get_call_by_sid(sid) do
    Call
    |> Repo.get_by!(sid: sid)
    |> Repo.preload([:user, :contact])
  end

  def get_call(id) do
    Call
    |> Repo.get!(id)
    |> Repo.preload([:user, :contact])
  end

  def start(call) do
    Twilio.call!(%{
      to: call.user.phone_number,
      url: dial_webhook(call)
    })
  end

  def recording_webhook(%Call{id: id}) do
    "#{base_url()}/webhooks/calls/#{id}/complete"
  end

  def dial_webhook(%Call{id: id}) do
    "#{base_url()}/webhooks/calls/#{id}/dial"
  end

  defp base_url do
    hostname = Application.get_env(:wiretap, :hostname)
    username = Application.get_env(:wiretap, :twilio_basic_auth_username)
    password = Application.get_env(:wiretap, :twilio_basic_auth_password)
    "https://#{username}:#{password}@#{hostname}"
  end

end

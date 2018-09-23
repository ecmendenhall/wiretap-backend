defmodule Wiretap.Calls.Call do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calls" do
    field :recording_url, :string

    belongs_to :user, Wiretap.Account.User
    belongs_to :contact, Wiretap.Contacts.Contact

    timestamps()
  end

  def changeset(call) do
    call
    |> cast(%{}, [:recording_url])
  end
end

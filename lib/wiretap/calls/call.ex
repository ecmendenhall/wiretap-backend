defmodule Wiretap.Calls.Call do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calls" do
    field :recording_url, :string
    field :sid, :string

    belongs_to :user, Wiretap.Account.User
    belongs_to :contact, Wiretap.Contacts.Contact

    timestamps()
  end

  def changeset(call, attrs) do
    call
    |> cast(attrs, [:recording_url, :sid])
  end
end

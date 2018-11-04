defmodule Wiretap.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wiretap.Formatters

  schema "users" do
    field :name, :string
    field :username, :string
    field :phone_number, :string
    field :password, Comeonin.Ecto.Password

    has_many :contacts, Wiretap.Contacts.Contact
    has_many :calls, Wiretap.Calls.Call
    has_one :feed, Wiretap.Feeds.Feed

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :phone_number, :password])
    |> validate_required([:name, :username, :password])
    |> validate_length(:username, min: 1, max: 25)
    |> Formatters.format_phone_number()
  end
end

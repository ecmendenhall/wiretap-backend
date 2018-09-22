defmodule Wiretap.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wiretap.Formatters

  schema "contacts" do
    field :name, :string
    field :phone_number, :string
    belongs_to :user, Wiretap.Account.User

    timestamps()
  end

  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :phone_number])
    |> validate_required([:name, :phone_number])
    |> Formatters.format_phone_number()
  end

end

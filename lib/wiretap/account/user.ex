defmodule Wiretap.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wiretap.Formatters

  schema "users" do
    field :name, :string
    field :username, :string
    field :phone_number, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :phone_number])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 25)
    |> Formatters.format_phone_number()
  end
end

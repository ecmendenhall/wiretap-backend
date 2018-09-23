defmodule Wiretap.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :title, :string, default: ""
    field :summary, :string, default: ""
    field :keywords, :string, default: ""
    field :is_explicit, :boolean, default: false

    belongs_to :user, Wiretap.Account.User
    has_many :entries, Wiretap.Feeds.Entry

    timestamps()
  end

  def changeset(call, attrs) do
    call
    |> cast(attrs, [:title, :summary, :keywords, :is_explicit])
  end

end

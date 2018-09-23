defmodule Wiretap.Feeds.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :title, :string, default: ""
    field :summary, :string, default: ""
    field :keywords, :string, default: ""
    field :is_explicit, :boolean, default: false

    belongs_to :feed, Wiretap.Feeds.Feed
    has_one :call, Wiretap.Calls.Call

    timestamps()
  end

  def changeset(call, attrs) do
    call
    |> cast(attrs, [:title, :summary, :keywords, :is_explicit])
  end

end

defmodule WiretapWeb.Schema do
  use Absinthe.Schema
  alias WiretapWeb.Resolvers

  query do
    field :user, :user do
      resolve &Resolvers.User.resolve_user/3
    end
  end

  object :user do
    field :id, :id
    field :name, :string
    field :username, :string
    field :phone_number, :string

    field :contacts, list_of(:contact) do
      resolve &Resolvers.User.user_contacts/3
    end

    field :calls, list_of(:call) do
      resolve &Resolvers.User.user_calls/3
    end

    field :feed, :feed do
      resolve &Resolvers.User.user_feed/3
    end
  end

  object :feed do
    field :id, :id
    field :title, :string
    field :summary, :string
    field :keywords, :string
    field :is_explicit, :boolean

    field :entries, list_of(:entry) do
      resolve &Resolvers.Feed.feed_entries/3
    end
  end

  object :entry do
    field :id, :id
    field :title, :string
    field :summary, :string
    field :keywords, :string
    field :is_explicit, :boolean

    field :call, :call do
      resolve &Resolvers.Entry.entry_call/3
    end
  end

  object :contact do
    field :id, :id
    field :name, :string
    field :phone_number, :string
  end

  object :call do
    field :id, :id
    field :recording_url, :string
    field :sid, :string

    field :from, :user do
      resolve &Resolvers.Call.call_user/3
    end

    field :to, :contact do
      resolve &Resolvers.Call.call_contact/3
    end
  end
end

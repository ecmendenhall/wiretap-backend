defmodule WiretapWeb.Schema do
  use Absinthe.Schema
  alias WiretapWeb.Resolvers

  query do
    field :user, :user do
      middleware WiretapWeb.Auth.Middleware
      resolve &Resolvers.User.resolve_user/3
    end
  end

  mutation do
    field :login, :session do
      arg :username, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Auth.login/3
    end

    field :create_contact, :contact do
      arg :input, non_null(:contact_input)
      resolve &Resolvers.Contact.create_contact/3
    end

    field :start_call, :call do
      arg :input, non_null(:call_input)
      resolve &Resolvers.Call.start_call/3
    end
  end

  input_object :call_input do
    field :contact_id, non_null(:id)
  end

  input_object :contact_input do
    field :name, non_null(:string)
    field :phone_number, non_null(:string)
  end

  object :session do
    field :token, :string
    field :user, :user
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

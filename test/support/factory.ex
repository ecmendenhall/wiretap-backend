defmodule Wiretap.Factory do
  alias Wiretap.{Account, Calls, Contacts, Feeds}

  def user(attrs \\ %{}) do
    defaults = %{
      name: "Flop Chonkenton",
      username: "flopchonk",
      phone_number: "+1 555 123 4567",
      password: "hunter2"
    }
    {:ok, user} = Account.create_user(Map.merge(defaults, attrs))
    user
  end

  def feed(attrs \\ %{}, existing_user \\ nil) do
    associated_user = if existing_user do
      existing_user
    else
      user()
    end
    defaults = %{
      title: "#{associated_user.name}'s Feed",
      summary: "Just another cool feed",
      keywords: "key, words",
      is_explicit: false
    }
    {:ok, feed} = Feeds.create_feed(Map.merge(defaults, attrs), associated_user)
    feed
  end

  def entry(attrs \\ %{}, existing_feed \\ nil, existing_call \\ nil) do
    associated_feed = if existing_feed do
      existing_feed
    else
      feed()
    end
    associated_call = if existing_call do
      existing_call
    else
      call(associated_feed.user)
    end
    defaults = %{
      title: "Feed entry",
      summary: "Just another cool entry",
      keywords: "key, words",
      is_explicit: false
    }
    {:ok, entry} = Feeds.create_entry(Map.merge(defaults, attrs), associated_feed, associated_call)
    entry
  end

  def contact(attrs \\ %{}, existing_user \\ nil) do
    associated_user = if existing_user do
      existing_user
    else
      user()
    end
    defaults = %{
      name: "Hot Saucerman",
      phone_number: "+1 555 765 4321"
    }
    {:ok, contact} = Contacts.create_contact(Map.merge(defaults, attrs), associated_user)
    contact
  end

  def call(existing_user \\ nil, existing_contact \\ nil) do
    associated_user = if existing_user do
      existing_user
    else
      user()
    end
    associated_contact = if existing_contact do
      existing_contact
    else
      contact(%{}, associated_user)
    end
    {:ok, call} = Calls.create_call(associated_user, associated_contact)
    call
  end

end

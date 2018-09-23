defmodule Wiretap.Factory do
  alias Wiretap.{Account, Calls, Contacts, Feeds}

  def user(attrs \\ %{}) do
    defaults = %{
      name: "Flop Chonkenton",
      username: "flopchonk",
      phone_number: "+1 555 123 4567"
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
      name: "#{associated_user.name}'s Feed",
    }
    {:ok, feed} = Feeds.create_feed(Map.merge(defaults, attrs), associated_user)
    feed
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

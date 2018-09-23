defmodule Wiretap.Contacts.ContactsTest do
  use Wiretap.DataCase

  alias Wiretap.Contacts
  alias Wiretap.Contacts.Contact
  alias Wiretap.Factory

  describe "creating a contact" do

    test "creates a contact" do
      user = Factory.user()
      {:ok, contact} = Contacts.create_contact(%{
        name: "Hot Saucerman",
        phone_number: "916-225-5887",
      }, user)
      assert %Contact{} = contact
    end

  end

  describe "getting a contact" do

    test "gets a contact when it exists" do
      user = Factory.user()
      {:ok, created_contact} = Contacts.create_contact(%{
        name: "Hot Saucerman",
        phone_number: "916-225-5887",
      }, user)
      assert created_contact = Contacts.get_contact(created_contact.id)
    end

    test "raises an error when contact not found" do
      assert_raise(Ecto.NoResultsError, fn ->
        Contacts.get_contact(1)
      end)
    end

  end

end

defmodule Wiretap.Callss.CallsTest do
  use Wiretap.DataCase

  alias Wiretap.Calls
  alias Wiretap.Calls.Call
  alias Wiretap.Account
  alias Wiretap.Contacts

  describe "creating a call" do

    test "creates a call" do
      {:ok, user} = Account.create_user(%{
        name: "Flop Chonkenton",
        username: "flopchonk",
      })
      {:ok, contact} = Contacts.create_contact(%{
        name: "Hot Saucerman",
        phone_number: "916-225-5887",
      }, user)
      {:ok, call} = Calls.create_call(user, contact)
      assert %Call{} = call
      assert call.user == user
      assert call.contact == contact
    end
  end

  describe "getting a call" do

    test "gets a call" do
      {:ok, user} = Account.create_user(%{
        name: "Flop Chonkenton",
        username: "flopchonk",
      })
      {:ok, contact} = Contacts.create_contact(%{
        name: "Hot Saucerman",
        phone_number: "916-225-5887",
      }, user)
      {:ok, created_call} = Calls.create_call(user, contact)
      assert created_call = Calls.get_call(created_call.id)
    end

    test "raises an error when call not found" do
      assert_raise(Ecto.NoResultsError, fn ->
        Calls.get_call(1)
      end)
    end

  end
end

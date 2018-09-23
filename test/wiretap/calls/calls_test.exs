defmodule Wiretap.Calls.CallsTest do
  use Wiretap.DataCase

  alias Wiretap.Factory
  alias Wiretap.Calls
  alias Wiretap.Calls.Call

  describe "creating a call" do

    test "creates a call" do
      contact = Factory.contact()
      {:ok, call} = Calls.create_call(contact.user, contact)
      assert %Call{} = call
      assert call.user == contact.user
      assert call.contact == contact
    end
  end

  describe "getting a call" do

    test "gets a call" do
      contact = Factory.contact()
      {:ok, created_call} = Calls.create_call(contact.user, contact)
      assert created_call = Calls.get_call(created_call.id)
    end

    test "raises an error when call not found" do
      assert_raise(Ecto.NoResultsError, fn ->
        Calls.get_call(1)
      end)
    end

  end
end

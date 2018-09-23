defmodule Wiretap.Account.AccountTest do
  use Wiretap.DataCase

  alias Wiretap.Account
  alias Wiretap.Account.User

  @valid_attrs %{
    name: "Flop Chonkenton",
    username: "flopchonk"
  }

  describe "creating a user" do
    test "creates a user with valid attributes" do
      {:ok, user} = Account.create_user(@valid_attrs)
      assert %User{name: "Flop Chonkenton", username: "flopchonk"} = user
      refute user.inserted_at == nil
      refute user.updated_at == nil
    end

    test "returns validation errors for invalid attributes" do
      {:error, %Ecto.Changeset{} = changeset} = Account.create_user(%{})
      refute changeset.valid?
    end
  end

  describe "getting a user" do
    test "gets a user when it exists" do
      {:ok, created_user} = Account.create_user(@valid_attrs)
      assert created_user = Account.get_user(created_user.id)
    end

    test "raises an error when user not found" do
      assert_raise(Ecto.NoResultsError, fn ->
        Account.get_user(1)
      end)
    end
  end


end

defmodule Wiretap.Account.UserTest do
  use Wiretap.DataCase

  alias Wiretap.Account.User

  test "user schema" do
    user = %User{
      name: "Flop Chonkenton",
      username: "flopchonk",
      phone_number: "+1 (555) 555-3226"
    }
    assert user.name == "Flop Chonkenton"
    assert user.username == "flopchonk"
    assert user.inserted_at == nil
    assert user.updated_at == nil
  end

  describe "changeset" do
    test "creates a changeset" do
      changeset = User.changeset(%User{}, %{})
      assert %Ecto.Changeset{} = changeset
    end

    test "excludes unknown attributes" do
      changeset = User.changeset(%User{}, %{unknown: "value"})
      assert %Ecto.Changeset{data: data} = changeset
      refute :unknown in Map.keys(data)
    end

    test "requires name" do
      changeset = User.changeset(%User{}, %{username: "flopchonk"})
      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires username" do
      changeset = User.changeset(%User{}, %{name: "Flop Chonkenton"})
      refute changeset.valid?
      assert %{username: ["can't be blank"]} = errors_on(changeset)
    end

    test "username max length" do
      changeset = User.changeset(%User{}, %{
        name: "Flop Chonkenton",
        username: "chonk-chonk-chonk-chonk-chonk-chonk"
      })
      refute changeset.valid?
      assert %{username: ["should be at most 25 character(s)"]} = errors_on(changeset)
    end

    test "converts phone number to E164" do
      changeset = User.changeset(%User{}, %{
        name: "Flop Chonkenton",
        username: "flopchonk",
        phone_number: "1 (555) 555-3226"
      })
      assert %Ecto.Changeset{changes: changes} = changeset
      assert changes.phone_number == "+15555553226"
    end
  end

end

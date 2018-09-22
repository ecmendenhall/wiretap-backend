defmodule Wiretap.Account.ContactTest do
  use Wiretap.DataCase

  alias Wiretap.Contacts.Contact

  test "contact schema" do
    contact = %Contact{
      name: "Hot Saucerman",
      phone_number: "+19162255887",
    }
    assert contact.name == "Hot Saucerman"
    assert contact.phone_number == "+19162255887"
    assert contact.inserted_at == nil
    assert contact.updated_at == nil
  end

  describe "changeset" do
    test "creates a changeset" do
      changeset = Contact.changeset(%Contact{}, %{})
      assert %Ecto.Changeset{} = changeset
    end

    test "excludes unknown attributes" do
      changeset = Contact.changeset(%Contact{}, %{unknown: "value"})
      assert %Ecto.Changeset{data: data} = changeset
      refute :unknown in Map.keys(data)
    end

    test "requires name" do
      changeset = Contact.changeset(%Contact{}, %{phone_number: "+19162255887"})
      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires phone number" do
      changeset = Contact.changeset(%Contact{}, %{name: "Hot Saucerman"})
      refute changeset.valid?
      assert %{phone_number: ["can't be blank"]} = errors_on(changeset)
    end

    test "converts phone number to E164" do
      changeset = Contact.changeset(%Contact{}, %{
        name: "Hot Saucerman",
        phone_number: "1 916-225-5887"
      })
      assert %Ecto.Changeset{changes: changes} = changeset
      assert changes.phone_number == "+19162255887"
    end
  end

end

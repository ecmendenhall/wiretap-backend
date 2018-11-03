defmodule WiretapWeb.Resolvers.ContactTest do
  use WiretapWeb.ConnCase

  alias Wiretap.Factory
  alias Wiretap.Repo
  alias Wiretap.Contacts

  describe "contacts" do

    @query """
    mutation ($contact: ContactInput!) {
      createContact(input: $contact) {
        name
        phoneNumber
      }
    }
    """
    test "creates a contact", %{conn: conn} do
      user = Factory.user()
      contact = %{
        "name" => "New Contact",
        "phoneNumber" => "+1 555 222 1234"
      }
      conn = post conn, "/api/graphql", %{
        query: @query,
        variables: %{
          "contact" => contact
        }
      }
      assert json_response(conn, 200)["data"] == %{
        "createContact" => %{
          "name" => "New Contact",
          "phoneNumber" => "+15552221234"
        }
      }
    end
  end
end

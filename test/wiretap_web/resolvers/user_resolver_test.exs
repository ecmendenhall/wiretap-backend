defmodule WiretapWeb.Resolvers.UserTest do
  use WiretapWeb.ConnCase

  alias Wiretap.Factory
  alias Wiretap.Repo

  describe "user" do

    @query """
    {
      user {
        id
        name
        username
        phoneNumber
      }
    }
    """
    test "returns user", %{conn: conn} do
      user = Factory.user()
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
            "id" => "#{user.id}",
            "name" =>  "Flop Chonkenton",
            "username" => "flopchonk",
            "phoneNumber" => "+15551234567"
          }
      }
    end
  end

  describe "user contacts" do

    @query """
    {
      user {
        contacts {
          id
          name
          phone_number
        }
      }
    }
    """
    test "returns contacts", %{conn: conn} do
      contact = Factory.contact() |> Repo.preload(:user)
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "contacts" => [
            %{
              "id" => "#{contact.id}",
              "name" => "Hot Saucerman",
              "phone_number" => "+15557654321"
            }
          ]
        }
      }
    end
  end

end

defmodule WiretapWeb.Resolvers.AuthTest do
  use WiretapWeb.ConnCase

  alias Wiretap.Factory

  describe "auth" do

    @query """
    mutation {
      login (username: "flopchonk", password: "hunter2") {
        token
        user { name }
      }
    }
    """
    test "returns valid session with valid credentials", %{conn: conn} do
      user = Factory.user()
      conn = post conn, "/api/graphql", %{query: @query}
      assert %{
        "login" => %{
          "token" => token,
          "user" => %{
            "name" => "Flop Chonkenton"
          }
        }
      } = json_response(conn, 200)["data"]
      assert {:ok, %{id: user.id}}== WiretapWeb.Auth.TokenAuth.verify(token)
    end

    @query """
    mutation {
      login (username: "flopchonk", password: "hunter3") {
        token
        user { name }
      }
    }
    """
    test "returns error with invalid credentials", %{conn: conn} do
      Factory.user()
      conn = post conn, "/api/graphql", %{query: @query}
      assert %{
        "login" =>  nil
      } = json_response(conn, 200)["data"]
    end
  end
end

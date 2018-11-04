defmodule WiretapWeb.Resolvers.EntryTest do
  use WiretapWeb.ConnCase

  alias Wiretap.Factory
  alias Wiretap.Repo

  describe "user feed entries" do

    @query """
    {
      user {
        feed {
          entries {
            call {
              id
            }
          }
        }
      }
    }
    """
    test "returns feed entries", %{conn: conn} do
      entry = Factory.entry() |> Repo.preload([:feed, :call])
      feed = entry.feed |> Repo.preload([:user])
      conn = auth_user(conn, feed.user)
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "feed" => %{
            "entries" => [
              %{"call" => %{
                "id" => "#{entry.call.id}"}
              }
            ]
          }
        }
      }
    end
  end
end

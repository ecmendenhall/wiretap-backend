defmodule WiretapWeb.Resolvers.FeedTest do
  use WiretapWeb.ConnCase

  alias Wiretap.Factory
  alias Wiretap.Repo

  describe "user feed" do

    @query """
    {
      user {
        feed {
          id
          title
          summary
          keywords
          is_explicit
        }
      }
    }
    """
    test "returns feed", %{conn: conn} do
      feed = Factory.feed() |> Repo.preload(:user)
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "feed" => %{
              "id" => "#{feed.id}",
              "title" => "Flop Chonkenton's Feed",
              "summary" => "Just another cool feed",
              "keywords" => "key, words",
              "is_explicit" => false
          }
        }
      }
    end

    @query """
    {
      user {
        feed {
          entries { id }
        }
      }
    }
    """
    test "returns feed entries", %{conn: conn} do
      entry = Factory.entry() |> Repo.preload(:feed)
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "feed" => %{
            "entries" => [
              %{"id" => "#{entry.id}"}
            ]
          }
        }
      }
    end
  end
end

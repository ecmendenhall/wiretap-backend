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
      conn = auth_user(conn, feed.user)
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
      feed = entry.feed |> Repo.preload(:user)
      conn = auth_user(conn, feed.user)
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

    @query """
    mutation($feedInput: FeedInput!) {
      updateFeed(input: $feedInput) {
        title
        summary
        keywords
        is_explicit
      }
    }
    """
    test "updates a feed", %{conn: conn} do
      feed = Factory.feed() |> Repo.preload([:user])
      updated_attrs = %{
        title: "Updated title",
        summary: "Updated summary",
        keywords: "updated, keywords",
        is_explicit: true
      }
      conn = auth_user(conn, feed.user)
      conn = post conn, "/api/graphql", %{
        query: @query,
        variables: %{
          "feedInput" => updated_attrs
        }
      }
      assert json_response(conn, 200)["data"] == %{
        "updateFeed" => %{
          "title" => "Updated title",
          "summary" => "Updated summary",
          "keywords" => "updated, keywords",
          "is_explicit" => true
        }
      }
    end
  end
end

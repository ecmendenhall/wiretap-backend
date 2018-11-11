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

  describe "updating an entry" do

    @query """
    mutation($id: String!, $entryInput: EntryInput!) {
      updateEntry(id: $id, input: $entryInput) {
        title
        summary
        keywords
        is_explicit
      }
    }
    """
    test "updates an entry", %{conn: conn} do
      entry = Factory.entry() |> Repo.preload([:feed, :call])
      feed = entry.feed |> Repo.preload([:user])
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
          "id" => entry.id,
          "entryInput" => updated_attrs
        }
      }
      assert json_response(conn, 200)["data"] == %{
        "updateEntry" => %{
          "title" => "Updated title",
          "summary" => "Updated summary",
          "keywords" => "updated, keywords",
          "is_explicit" => true
        }
      }
    end
  end
end

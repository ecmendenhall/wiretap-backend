defmodule WiretapWeb.Resolvers.CallTest do
  use WiretapWeb.ConnCase

  alias Wiretap.Factory
  alias Wiretap.Repo
  alias Wiretap.Calls

  describe "user calls" do

    @query """
    {
      user {
        calls {
          id
          recording_url
          sid
        }
      }
    }
    """
    test "returns calls", %{conn: conn} do
      call = Factory.call() |> Repo.preload(:user)
      {:ok, call} = Calls.update_call(call, %{
        recording_url: "https://example.com/recording.mp3",
        sid: "abc123"
      })
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "calls" => [
            %{
              "id" => "#{call.id}",
              "recording_url" => "https://example.com/recording.mp3",
              "sid" => "abc123"
            }
          ]
        }
      }
    end

    @query """
    {
      user {
        calls {
          from { id }
        }
      }
    }
    """
    test "returns call user", %{conn: conn} do
      call = Factory.call() |> Repo.preload(:user)
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "calls" => [
            %{
              "from" => %{"id" => "#{call.user.id}"}
            }
          ]
        }
      }
    end

    @query """
    {
      user {
        calls {
          to { id }
        }
      }
    }
    """
    test "returns call contact", %{conn: conn} do
      call = Factory.call() |> Repo.preload([:user, :contact])
      conn = post conn, "/api/graphql", %{query: @query}
      assert json_response(conn, 200)["data"] == %{
        "user" => %{
          "calls" => [
            %{
              "to" => %{"id" => "#{call.contact.id}"}
            }
          ]
        }
      }
    end
  end
end

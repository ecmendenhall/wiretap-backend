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
      conn = auth_user(conn, call.user)
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
      conn = auth_user(conn, call.user)
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
      conn = auth_user(conn, call.user)
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

    @query """
    mutation ($callInput: CallInput!) {
      startCall(input: $callInput) {
        id
        recordingUrl
        sid
      }
    }
    """
    test "starts a call", %{conn: conn} do
      contact = Factory.contact() |> Repo.preload([:user])
      call_input = %{
        "contactId" => contact.id
      }
      conn = post conn, "/api/graphql", %{
        query: @query,
        variables: %{
          "callInput" => call_input
        }
      }
      user = contact.user |> Repo.preload([:calls])
      [call] = user.calls
      assert json_response(conn, 200)["data"] == %{
        "startCall" => %{
          "id" => "#{call.id}",
          "recordingUrl" => call.recording_url,
          "sid" => call.sid
        }
      }
    end
  end
end

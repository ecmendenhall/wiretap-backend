defmodule WiretapWeb.PageControllerTest do
  use WiretapWeb.ConnCase
  alias Wiretap.Calls
  alias Wiretap.Factory

  describe "basic authentication" do
    test "requests without Authorization header return 401", %{conn: conn} do
      conn = post conn, "/webhooks/calls/1/dial", %{"CallSid" => "abc123"}
      assert response(conn, 401)
    end

    test "unauthorized response adds WWW-Authenticate header", %{conn: conn} do
      conn = post conn, "/webhooks/calls/1/dial", %{"CallSid" => "abc123"}
      %{resp_headers: headers} = conn
      assert {"www-authenticate", "Basic realm=\"wiretap\""} in headers
    end

    test "authorized response returns non-401", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      assert_error_sent :not_found, fn ->
        post conn, "/webhooks/calls/1/dial", %{"CallSid" => "abc123"}
      end
    end
  end

  describe "generating TwiML" do
    test "gets associated call", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/calls/#{call.id}/dial", %{"CallSid" => "abc123"}
      assert response(conn, 200)
    end

    test "sets sid on associated call", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      post conn, "/webhooks/calls/#{call.id}/dial", %{"CallSid" => "abc123"}
      call = Calls.get_call(call.id)
      assert call.sid == "abc123"
    end

    test "call TwiML embeds contact numnber", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/calls/#{call.id}/dial", %{"CallSid" => "abc123"}
      assert conn.resp_body =~ "+15557654321"
    end
  end

  describe "recording callback" do
    test "gets associated call", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/calls/#{call.id}/complete", %{"RecordingUrl" => "https://example.com/recording.mp3"}
      assert response(conn, 200)
    end

    test "sets recording URL on associated call", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      post conn, "/webhooks/calls/#{call.id}/complete", %{"RecordingUrl" => "https://example.com/recording.mp3"}
      call = Calls.get_call(call.id)
      assert call.recording_url == "https://example.com/recording.mp3"
    end
  end

end

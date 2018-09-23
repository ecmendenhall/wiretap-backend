defmodule WiretapWeb.PageControllerTest do
  use WiretapWeb.ConnCase
  alias Wiretap.Factory

  describe "basic authentication" do
    test "requests without Authorization header return 401", %{conn: conn} do
      conn = post conn, "/webhooks/call/1"
      assert response(conn, 401)
    end

    test "unauthorized response adds WWW-Authenticate header", %{conn: conn} do
      conn = post conn, "/webhooks/call/1"
      %{resp_headers: headers} = conn
      assert {"www-authenticate", "Basic realm=\"wiretap\""} in headers
    end

    test "authorized response returns non-401", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      assert_error_sent :not_found, fn ->
        post conn, "/webhooks/call/1"
      end
    end
  end

  describe "generating TwiML" do
    test "gets associated call", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/call/#{call.id}"
      assert response(conn, 200)
    end

    test "call TwiML embeds contact numnber", %{conn: conn} do
      call = Factory.call()
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/call/#{call.id}"
      assert conn.resp_body =~ "<Dial record=\"record-from-ringing\">+15557654321</Dial>"
    end
  end
end

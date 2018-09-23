defmodule WiretapWeb.PageControllerTest do
  use WiretapWeb.ConnCase

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

    test "authorized response returns 200", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/call/1"
      assert response(conn, 200)
    end
  end
end

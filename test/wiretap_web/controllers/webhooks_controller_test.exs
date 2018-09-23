defmodule WiretapWeb.PageControllerTest do
  use WiretapWeb.ConnCase
  alias Wiretap.{Account, Contacts, Calls}

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
      {:ok, user} = Account.create_user(%{
        name: "Mauve Sweaterman",
        username: "coolmauvysweats",
        phone_number: "+15558901234"
      })
      {:ok, contact} = Contacts.create_contact(%{
        name: "Great Fostermom",
        phone_number: "+15551234567"
      }, user)
      {:ok, call} = Calls.create_call(user, contact)
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/call/#{call.id}"
      assert response(conn, 200)
    end

    test "call TwiML embeds contact numnber", %{conn: conn} do
      {:ok, user} = Account.create_user(%{
        name: "Mauve Sweaterman",
        username: "coolmauvysweats",
        phone_number: "+15558901234"
      })
      {:ok, contact} = Contacts.create_contact(%{
        name: "Great Fostermom",
        phone_number: "+15551234567"
      }, user)
      {:ok, call} = Calls.create_call(user, contact)
      conn = put_req_header(conn, "authorization", "Basic dHdpbGlvOnRlc3QtcGFzc3dvcmQ=")
      conn = post conn, "/webhooks/call/#{call.id}"
      assert conn.resp_body =~ "<Dial record=\"record-from-ringing\">+15551234567</Dial>"
    end
  end
end

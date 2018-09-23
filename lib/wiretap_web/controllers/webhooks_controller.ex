defmodule WiretapWeb.WebhooksController do
  use WiretapWeb, :controller
  alias Wiretap.Calls

  def connect_call(conn, %{"id" => id }) do
    call = Calls.get_call(id)
    conn
    |> put_resp_content_type("text/xml")
    |> render("call.twiml", call: call)
  end
end

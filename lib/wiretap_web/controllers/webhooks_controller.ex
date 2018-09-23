defmodule WiretapWeb.WebhooksController do
  use WiretapWeb, :controller

  def connect_call(conn, %{"id" => _id }) do
    render conn, "call.twiml"
  end
end

defmodule WiretapWeb.WebhooksController do
  use WiretapWeb, :controller
  alias Wiretap.Calls

  def dial(conn, %{"id" => id, "CallSid" => sid}) do
    call = Calls.get_call(id)
    {:ok, call} = Calls.update_call(call, %{sid: sid})
    conn
    |> put_resp_content_type("text/xml")
    |> render("call.twiml", call: call)
  end

  def complete(conn, %{"id" => id, "RecordingUrl" => recording_url}) do
    call = Calls.get_call(id)
    {:ok, call} = Calls.update_call(call, %{recording_url: recording_url})
    conn
    |> send_resp(:ok, "")
  end

end

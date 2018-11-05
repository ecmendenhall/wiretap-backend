defmodule WiretapWeb.WebhooksController do
  use WiretapWeb, :controller
  alias Wiretap.Repo
  alias Wiretap.Calls
  alias Wiretap.Feeds

  def dial(conn, %{"id" => id, "CallSid" => sid}) do
    call = Calls.get_call(id)
    {:ok, call} = Calls.update_call(call, %{sid: sid})
    callback = Calls.recording_webhook(call)
    conn
    |> put_resp_content_type("text/xml")
    |> render("call.twiml", call: call, callback: callback)
  end

  def complete(conn, %{"id" => id, "RecordingUrl" => recording_url}) do
    call = Calls.get_call(id) |> Repo.preload([:user])
    {:ok, _call} = Calls.update_call(call, %{recording_url: recording_url})
    user = call.user |> Repo.preload([:feed])
    if user.feed do
      {:ok, _entry} = Feeds.create_entry(%{}, user.feed, call)
    else
      {:ok, feed} = Feeds.create_feed(%{}, user)
      {:ok, _entry} = Feeds.create_entry(%{}, feed, call)
    end
    conn
    |> send_resp(:ok, "")
  end

end

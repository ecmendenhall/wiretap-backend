defmodule WiretapWeb.FeedsController do
  use WiretapWeb, :controller
  alias Wiretap.Account
  alias Wiretap.Repo

  def show(conn, %{"username" => _username}) do
    user = Account.get_user(1) |> Repo.preload(:calls)
    conn |> put_resp_content_type("text/xml") |> render("feed.xml", user: user)
  end

end

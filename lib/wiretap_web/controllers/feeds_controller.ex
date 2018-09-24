defmodule WiretapWeb.FeedsController do
  use WiretapWeb, :controller
  alias Wiretap.Account
  alias WiretapWeb.Presenters.FeedPresenter

  def show(conn, %{"username" => username}) do
    user = Account.get_by_username(username)
    %{feed: feed} = FeedPresenter.gather_attrs(user)
    conn
    |> put_resp_content_type("text/xml")
    |> render("feed.xml", feed: feed)
  end

end

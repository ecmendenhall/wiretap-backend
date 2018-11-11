defmodule WiretapWeb.Resolvers.Feed do
  alias Wiretap.Feeds
  alias Wiretap.Feeds.Feed
  alias Wiretap.Repo

  def feed_entries(%Feed{} = feed, _, _) do
    feed = Repo.preload(feed, :entries)
    {:ok, feed.entries}
  end

  def update_feed(_, %{input: input}, %{context: context}) do
    %{current_user: user} = context
    user = user |> Repo.preload([:feed])
    Feeds.update_feed(user.feed, input)
  end

end

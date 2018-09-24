defmodule WiretapWeb.Resolvers.Feed do
  alias Wiretap.Feeds.Feed
  alias Wiretap.Repo

  def feed_entries(%Feed{} = feed, _, _) do
    feed = Repo.preload(feed, :entries)
    {:ok, feed.entries}
  end

end

defmodule WiretapWeb.Presenters.FeedPresenterTest do
  use Wiretap.DataCase

  alias Wiretap.Repo
  alias Wiretap.Factory
  alias WiretapWeb.Presenters.FeedPresenter
  alias WiretapWeb.Presenters.EntryPresenter

  test "gathers feed attributes for user" do
    published_entry = Factory.entry(%{
      published: true
    })
    feed = published_entry.feed |> Repo.preload([:user])
    user = feed.user |> Repo.preload([:feed])
    unpublished_entry = Factory.entry(%{}, feed)
    feed_attrs = FeedPresenter.gather_attrs(user)
    assert feed_attrs == %{
      feed: %{
        title: "Flop Chonkenton's Feed",
        link: "/feeds/flopchonk",
        image: "https://www.placecage.com/600/600.jpg",
        copyright: "Copyright Flop Chonkenton 2018",
        author: "Flop Chonkenton",
        summary: "Just another cool feed",
        explicit: "No",
        keywords: "wiretap, key, words",
        last_build: Timex.format!(published_entry.feed.updated_at, "%a, %d %b %Y %T UTC", :strftime),
        last_update: Timex.format!(published_entry.updated_at, "%a, %d %b %Y %T UTC", :strftime),
        entries: [EntryPresenter.gather_attrs(published_entry)]
      }
    }
  end

  test "uses default title when title is blank" do
    user = Factory.user()
    Factory.feed(%{title: ""}, user)
    feed_attrs = FeedPresenter.gather_attrs(user)
    assert feed_attrs.feed.title == "Flop Chonkenton's Wiretap feed"
  end

  test "uses default summary when summary is blank" do
    user = Factory.user()
    Factory.feed(%{summary: ""}, user)
    feed_attrs = FeedPresenter.gather_attrs(user)
    assert feed_attrs.feed.summary == "Listen in on Flop Chonkenton's phone calls"
  end

end

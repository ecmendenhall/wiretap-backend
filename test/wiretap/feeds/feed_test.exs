defmodule Wiretap.Feeds.FeedTest do
  use Wiretap.DataCase

  alias Wiretap.Feeds.Feed

  test "feed schema" do
    feed = %Feed{
      title: "Flop Chonkenton's Wiretap Feed",
      summary: "What's up, hot dog?",
      keywords: "flop, chonk, hot, dog",
      is_explicit: false
    }
    assert feed.title == "Flop Chonkenton's Wiretap Feed"
    assert feed.summary == "What's up, hot dog?"
    assert feed.keywords == "flop, chonk, hot, dog"
    refute feed.is_explicit
  end

  describe "changeset" do
    test "creates a changeset" do
      changeset = Feed.changeset(%Feed{}, %{})
      assert %Ecto.Changeset{} = changeset
    end

    test "excludes unknown attributes" do
      changeset = Feed.changeset(%Feed{}, %{unknown: "value"})
      assert %Ecto.Changeset{data: data} = changeset
      refute :unknown in Map.keys(data)
    end
  end


end

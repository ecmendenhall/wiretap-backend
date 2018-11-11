defmodule Wiretap.Feeds.FeedsTest do
  use Wiretap.DataCase

  alias Wiretap.Factory
  alias Wiretap.Feeds
  alias Wiretap.Feeds.{Feed, Entry}

  describe "feeds" do

    test "creates a feed" do
      user = Factory.user()
      {:ok, feed} = Feeds.create_feed(%{
        title: "Flop Chonkenton's Feed",
        summary: "What's up hot dog?",
        keywords: "flop, chonk, hot, dog",
        is_explicit: true
      }, user)
      assert %Feed{} = feed
      assert feed.user == user
      assert feed.title == "Flop Chonkenton's Feed"
      assert feed.summary == "What's up hot dog?"
      assert feed.keywords == "flop, chonk, hot, dog"
      assert feed.is_explicit
    end

    test "updatess a feed" do
      user = Factory.user()
      {:ok, feed} = Feeds.create_feed(%{
        title: "Flop Chonkenton's Feed",
        summary: "What's up hot dog?",
        keywords: "flop, chonk, hot, dog",
        is_explicit: true
      }, user)
      {:ok, feed} = Feeds.update_feed(feed, %{
        title: "Updated title",
        summary: "Updated summary",
        keywords: "updated, keywords",
        is_explicit: false
      })
      assert %Feed{} = feed
      assert feed.user == user
      assert feed.title == "Updated title"
      assert feed.summary == "Updated summary"
      assert feed.keywords == "updated, keywords"
      refute feed.is_explicit
    end
  end

  describe "entries" do

    test "creates an entry" do
      call = Factory.call()
      feed = Factory.feed(%{}, call.user)
      {:ok, entry} = Feeds.create_entry(%{
        title: "Flop Chonkenton's Feed",
        summary: "What's up hot dog?",
        keywords: "flop, chonk, hot, dog",
        is_explicit: true
      }, feed, call)
      assert %Entry{} = entry
      assert entry.feed.id == feed.id
      assert entry.call.id == call.id
      assert entry.title == "Flop Chonkenton's Feed"
      assert entry.summary == "What's up hot dog?"
      assert entry.keywords == "flop, chonk, hot, dog"
      assert entry.is_explicit
    end

    test "updates an entry" do
      call = Factory.call()
      feed = Factory.feed(%{}, call.user)
      {:ok, entry} = Feeds.create_entry(%{
        title: "Flop Chonkenton's Feed",
        summary: "What's up hot dog?",
        keywords: "flop, chonk, hot, dog",
        is_explicit: true
      }, feed, call)
      {:ok, entry} = Feeds.update_entry(entry, %{
        title: "Updated title",
        summary: "Updated summary",
        keywords: "updated, keywords",
        is_explicit: false
      })
      assert %Entry{} = entry
      assert entry.feed.id == feed.id
      assert entry.call.id == call.id
      assert entry.title == "Updated title"
      assert entry.summary == "Updated summary"
      assert entry.keywords == "updated, keywords"
      refute entry.is_explicit
    end
  end


end

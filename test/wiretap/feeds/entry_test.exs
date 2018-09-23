defmodule Wiretap.Feeds.EntryTest do
  use Wiretap.DataCase

  alias Wiretap.Feeds.Entry

  test "entry schema" do
    entry = %Entry{
      title: "Feed Entry",
      summary: "Summary of this entry",
      keywords: "feed, entry",
      is_explicit: true
    }
    assert entry.title == "Feed Entry"
    assert entry.summary == "Summary of this entry"
    assert entry.keywords == "feed, entry"
    assert entry.is_explicit
  end

  describe "changeset" do
    test "creates a changeset" do
      changeset = Entry.changeset(%Entry{}, %{})
      assert %Ecto.Changeset{} = changeset
    end

    test "excludes unknown attributes" do
      changeset = Entry.changeset(%Entry{}, %{unknown: "value"})
      assert %Ecto.Changeset{data: data} = changeset
      refute :unknown in Map.keys(data)
    end
  end


end

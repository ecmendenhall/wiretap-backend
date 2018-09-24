defmodule WiretapWeb.Presenters.EntryPresenterTest do
  use Wiretap.DataCase

  alias Wiretap.Factory
  alias WiretapWeb.Presenters.EntryPresenter

  test "gathers feed attributes for user" do
    entry = Factory.entry()
    {:ok, _call} = Wiretap.Calls.update_call(
      entry.call,
      %{recording_url: "https://example.com/recording"}
    )
    entry = Wiretap.Feeds.get_entry(entry.id)
    entry_attrs = EntryPresenter.gather_attrs(entry)

    assert entry_attrs == %{
      title: "Feed entry",
      media_url: "https://example.com/recording.mp3",
      image: "https://www.placecage.com/600/600.jpg",
      summary: "Just another cool entry",
      explicit: "No",
      keywords: "wiretap, key, words",
      published: Timex.format!(entry.updated_at, "%a, %d %b %Y %T UTC", :strftime)
    }
  end

  test "uses contact name as title when blank" do
    entry = Factory.entry(%{
      title: ""
    })
    entry_attrs = EntryPresenter.gather_attrs(entry)
    assert entry_attrs.title == "Hot Saucerman"
  end

  test "uses default summary when blank" do
    entry = Factory.entry(%{
      summary: ""
    })
    entry_attrs = EntryPresenter.gather_attrs(entry)
    assert entry_attrs.summary == "Flop Chonkenton calls Hot Saucerman"
  end

end

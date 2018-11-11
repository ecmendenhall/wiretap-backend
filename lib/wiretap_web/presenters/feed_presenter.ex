defmodule WiretapWeb.Presenters.FeedPresenter do
  alias Wiretap.Account.User
  alias Wiretap.Feeds.Feed
  alias Wiretap.Repo
  alias WiretapWeb.Presenters.EntryPresenter

  @rfc_2822_format "%a, %d %b %Y %T UTC"

  def gather_attrs(%User{} = user) do
    user = Repo.preload(user, :feed)
    feed = Repo.preload(user.feed, entries: Feed.published_entries)
    %{
      feed: %{
        title: title(user, feed),
        link: link(user),
        image: image(feed),
        copyright: copyright(user),
        author: user.name,
        summary: summary(user, feed),
        explicit: explicit(feed),
        keywords: keywords(feed),
        last_build: last_build(feed),
        last_update: last_update(feed),
        entries: Enum.map(feed.entries, &EntryPresenter.gather_attrs/1)
      }
    }
  end

  defp title(%User{name: name}, %Feed{title: title}) do
    case title do
      "" ->
        "#{name}'s Wiretap feed"
      _ ->
        title
    end
  end

  defp link(%User{username: username}) do
    "/feeds/#{username}"
  end

  defp image(%Feed{} = _feed) do
    "https://www.placecage.com/600/600.jpg"
  end

  defp copyright(%User{name: name}) do
    "Copyright #{name} #{DateTime.utc_now.year}"
  end

  defp summary(%User{name: name}, %Feed{summary: summary}) do
    case summary do
      "" ->
        "Listen in on #{name}'s phone calls"
      _ ->
        summary
    end
  end

  defp explicit(%Feed{is_explicit: is_explicit}) do
    if is_explicit do
      "Yes"
    else
      "No"
    end
  end

  defp keywords(%Feed{keywords: keywords}) do
    "wiretap, #{keywords}"
  end

  defp last_build(%Feed{updated_at: updated_at}) do
    {:ok, date} = Timex.format(updated_at, @rfc_2822_format, :strftime)
    date
  end

  defp last_update(%Feed{} = feed) do
    latest_entry = List.last(feed.entries)
    if latest_entry do
      {:ok, date} = Timex.format(latest_entry.updated_at, @rfc_2822_format, :strftime)
      date
    else
      last_build(feed)
    end
  end


end

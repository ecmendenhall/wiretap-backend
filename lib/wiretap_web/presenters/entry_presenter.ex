defmodule WiretapWeb.Presenters.EntryPresenter do
  alias Wiretap.Feeds.Entry
  alias Wiretap.Calls.Call
  alias Wiretap.Repo

  @rfc_2822_format "%a, %d %b %Y %T UTC"

  def gather_attrs(%Entry{} = entry) do
    entry = Repo.preload(entry, :call)
    call = Repo.preload(entry.call, [:user, :contact])
    %{
      title: title(entry, call),
      media_url: media_url(call),
      image: image(entry),
      summary: summary(entry, call),
      explicit: explicit(entry),
      keywords: keywords(entry),
      published: published(entry),
    }
  end

  defp title(%Entry{title: title}, %Call{} = call) do
    case title do
      "" ->
        "#{call.contact.name}"
      _ ->
        title
    end
  end

  defp media_url(%Call{recording_url: recording_url}) do
    "#{recording_url}.mp3"
  end

  defp image(%Entry{} = _feed) do
    "https://www.placecage.com/600/600.jpg"
  end

  defp summary(%Entry{summary: summary}, %Call{} = call) do
    case summary do
      "" ->
        "#{call.user.name} calls #{call.contact.name}"
      _ ->
        summary
    end
  end

  defp explicit(%Entry{is_explicit: is_explicit}) do
    if is_explicit do
      "Yes"
    else
      "No"
    end
  end

  defp keywords(%Entry{keywords: keywords}) do
    "wiretap, #{keywords}"
  end

  defp published(%Entry{updated_at: updated_at}) do
    {:ok, date} = Timex.format(updated_at, @rfc_2822_format, :strftime)
    date
  end

end

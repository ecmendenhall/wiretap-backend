defmodule Wiretap.Feeds do
  alias Wiretap.Repo
  alias Ecto.Changeset
  alias Wiretap.Feeds.{Feed, Entry}
  alias Twilio

  def create_feed(attrs, user) do
    %Feed{}
    |> Feed.changeset(attrs)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert
  end

  def create_entry(attrs, feed, call) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Changeset.put_assoc(:feed, feed)
    |> Changeset.put_assoc(:call, call)
    |> Repo.insert
  end

end


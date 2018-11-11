defmodule WiretapWeb.Resolvers.Entry do
  alias Wiretap.Feeds
  alias Wiretap.Feeds.Entry
  alias Wiretap.Repo

  def entry_call(%Entry{} = entry, _, _) do
    entry = Repo.preload(entry, :call)
    {:ok, entry.call}
  end

  def update_entry(_, %{id: id, input: input}, _) do
    entry = Feeds.get_entry(id)
    Feeds.update_entry(entry, input)
  end

end

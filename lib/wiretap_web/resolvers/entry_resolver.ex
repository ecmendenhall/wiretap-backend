defmodule WiretapWeb.Resolvers.Entry do
  alias Wiretap.Calls.Call
  alias Wiretap.Feeds.Entry
  alias Wiretap.Repo

  def entry_call(%Entry{} = entry, _, _) do
    entry = Repo.preload(entry, :call)
    {:ok, entry.call}
  end

end

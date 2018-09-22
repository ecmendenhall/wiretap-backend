# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wiretap,
  ecto_repos: [Wiretap.Repo]

# Configures the endpoint
config :wiretap, WiretapWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7CZ4NOw6fPxYBsmk4ETGJ2ay0ftRxQeUIxzxj7sQ0iXrVKbK6u/D9ZJTAiE8GVb2",
  render_errors: [view: WiretapWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Wiretap.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

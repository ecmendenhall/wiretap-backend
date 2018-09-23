use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wiretap, WiretapWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wiretap, Wiretap.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wiretap_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :wiretap,
  twilio_account_sid: "test-twilio-account-sid",
  twilio_auth_token: "test-twilio-auth-token",
  twilio_outgoing_number: "+15207294567"

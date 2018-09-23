defmodule WiretapWeb.Router do
  use WiretapWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :webhooks do
    plug :accepts, ["json"]
    plug WiretapWeb.Auth.BasicAuth,
      realm: "wiretap",
      username: "twilio",
      password: "test-password"
  end

  scope "/api", WiretapWeb do
    pipe_through :api
  end

  scope "/webhooks", WiretapWeb do
    pipe_through :webhooks
    post "/call/:id", WebhooksController, :connect_call
  end
end

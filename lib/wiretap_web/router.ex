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

  pipeline :feeds do
    plug :accepts, ["xml"]
  end

  scope "/api" do
    pipe_through :api
    forward "/graphql", Absinthe.Plug, schema: WiretapWeb.Schema
  end

  scope "/webhooks", WiretapWeb do
    pipe_through :webhooks
    post "/calls/:id/dial", WebhooksController, :dial
    post "/calls/:id/complete", WebhooksController, :complete
  end

  scope "/feeds", WiretapWeb do
    pipe_through :feeds
    get "/:username", FeedsController, :show
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WiretapWeb.Schema,
      interface: :simple
end

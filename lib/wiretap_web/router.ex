defmodule WiretapWeb.Router do
  use WiretapWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WiretapWeb do
    pipe_through :api
  end
end

defmodule WiretapWeb.Resolvers.Auth do
  alias WiretapWeb.Auth.PasswordAuth
  alias WiretapWeb.Auth.TokenAuth

  def login(_, %{username: username, password: password}, _) do
    case PasswordAuth.authenticate(username, password) do
      {:ok, user} ->
        token = TokenAuth.generate_token(user)
        {:ok, %{token: token, user: user}}
      _ ->
        {:error, "Incorrect username or password"}
    end
  end
end

defmodule WiretapWeb.Resolvers.Auth do
  alias WiretapWeb.Auth.PasswordAuth
  alias WiretapWeb.Auth.TokenAuth

  def login(_, params, _) do
    authenticate(params)
  end

  def signup(_, %{input: params}, _) do
    {:ok, user} = Wiretap.Account.create_user(params)
    authenticate(params)
  end

  defp authenticate(%{username: username, password: password}) do
    case PasswordAuth.authenticate(username, password) do
      {:ok, user} ->
        token = TokenAuth.generate_token(user)
        {:ok, %{token: token, user: user}}
      _ ->
        {:error, "Incorrect username or password"}
    end
  end
end

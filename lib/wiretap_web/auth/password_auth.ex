defmodule WiretapWeb.Auth.PasswordAuth do
  alias Comeonin.Ecto.Password
  alias Wiretap.Account

  def authenticate(username, password) do
    user = Account.get_by_username(username)
    with %{password: hash} <- user,
    true <- Password.valid?(password, hash) do
      {:ok, user}
    else
      _ -> :error
    end
  end
end

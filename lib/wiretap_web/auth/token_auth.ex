defmodule WiretapWeb.Auth.TokenAuth do
  alias Comeonin.Ecto.Password
  alias Wiretap.Account

  @salt "users"

  def generate_token(user) do
    data = %{id: user.id}
    Phoenix.Token.sign(WiretapWeb.Endpoint, @salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(WiretapWeb.Endpoint, @salt, token, [
      max_age: 365 * 24 * 3600
    ])
  end
end

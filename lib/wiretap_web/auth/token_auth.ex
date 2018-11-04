defmodule WiretapWeb.Auth.TokenAuth do
  @namespace "users"

  def generate_token(user) do
    data = %{id: user.id}
    Phoenix.Token.sign(WiretapWeb.Endpoint, @namespace, data)
  end

  def verify(token) do
    Phoenix.Token.verify(WiretapWeb.Endpoint, @namespace, token, [
      max_age: 365 * 24 * 3600
    ])
  end
end

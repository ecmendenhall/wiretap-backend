defmodule WiretapWeb.Auth.TokenAuthTest do
  use Wiretap.DataCase

  alias Wiretap.Factory
  alias WiretapWeb.Auth.TokenAuth

  test "verifies valid token" do
    user = Factory.user()
    token = TokenAuth.generate_token(user)
    valid_data = %{id: user.id}
    assert {:ok, valid_data} == TokenAuth.verify(token)
  end

  test "rejects invalid token" do
    assert {:error, :invalid} = TokenAuth.verify("invalid token")
  end
end

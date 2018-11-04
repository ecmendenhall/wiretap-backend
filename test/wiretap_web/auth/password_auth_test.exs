defmodule WiretapWeb.Auth.PasswordAuthTest do
  use Wiretap.DataCase

  alias Wiretap.Factory
  alias WiretapWeb.Auth.PasswordAuth

  test "returns user for valid password" do
    %{username: username} = Factory.user()
    assert {:ok, user} = PasswordAuth.authenticate(
      username,
      "hunter2"
    )
  end

  test "returns error for invalid password" do
    %{username: username} = Factory.user()
    assert :error = PasswordAuth.authenticate(
      username,
      "hunter3"
    )
  end

end

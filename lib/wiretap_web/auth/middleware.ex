defmodule WiretapWeb.Auth.Middleware do
  @behaviour Absinthe.Middleware

  alias Wiretap.Account.User

  def call(resolution, _) do
    with %{current_user: user} <- resolution.context do
      case user do
        %User{} ->
          resolution
        %{} -> unauthorized(resolution)
      end
    else
      _ -> unauthorized(resolution)
    end
  end

  defp unauthorized(resolution) do
    resolution
    |> Absinthe.Resolution.put_result({:error, "unauthorized"})
  end
end

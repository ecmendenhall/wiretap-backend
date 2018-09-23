defmodule WiretapWeb.Auth.BasicAuth do
  alias Plug.Conn
  require Logger

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    [realm: realm, username: username, password: password] = opts
    if authenticated?(conn, {username, password}) do
      conn
    else
      conn
      |> Conn.put_resp_header("www-authenticate", "Basic realm=\"#{realm}\"")
      |> Conn.send_resp(:unauthorized, "")
      |> Conn.halt()
    end
  end

  defp authenticated?(conn, credentials) do
    with {:ok, header} <- get_auth_header(conn),
         {:ok, decoded} <- decode(header),
         claim <- split(decoded) do
      verify(claim, credentials)
    else
      _ ->
        false
    end
  end

  defp get_auth_header(conn) do
    case Conn.get_req_header(conn, "authorization") do
      [] -> :unauthorized
      [header] -> {:ok, header}
    end
  end

  defp decode(auth_header) do
    with "Basic " <> encoded <- auth_header do
      Base.decode64(encoded)
    else
      _ -> :unauthorized
    end
  end

  defp split(auth_string) do
    auth_string
    |> String.split(":")
    |> List.to_tuple()
  end

  defp verify(claim, credentials) do
    claim == credentials
  end

end

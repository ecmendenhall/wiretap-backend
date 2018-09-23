defmodule Twilio do
  alias Twilio.Request

  def call!(attrs) do
    call_request(attrs)
    |> send_request()
  end

  def call_request(%{to: to, url: url}) do
    %Request{
      method: :post,
      resource: path("Calls.json"),
    }
    |> Request.add_param("To", to)
    |> Request.add_param("From", outgoing_number())
    |> Request.add_param("Url", url)
    |> Request.to_tuple
  end

  def path(path) do
    "https://api.twilio.com/2010-04-01/Accounts/#{account_sid()}/#{path}"
  end

  defp outgoing_number do
    Application.get_env(:wiretap, :twilio_outgoing_number)
  end

  defp auth_token do
    Application.get_env(:wiretap, :twilio_auth_token)
  end

  defp account_sid do
    Application.get_env(:wiretap, :twilio_account_sid)
  end

  defp send_request({method, resource, params}) do
    case HTTPoison.request(
      method,
      resource,
      {:form, params},
      [],
      hackney: [
        {:basic_auth, {account_sid(), auth_token()}}
      ]
    ) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        Poison.decode(body)
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok, body} = Poison.decode(body)
        {:error, body}
      err ->
        {:error, err}
    end
  end
end

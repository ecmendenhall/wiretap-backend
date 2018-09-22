defmodule Wiretap.Phone do

  def format_number(phone_number) do
    with {:ok, phone_number} <- ExPhoneNumber.parse(phone_number, "US") do
      {:ok, ExPhoneNumber.format(phone_number, :e164)}
    else
      {:error, "The string supplied did not seem to be a phone number"} ->
        {:error, "Invalid phone number"}
      err -> err
    end
  end
end

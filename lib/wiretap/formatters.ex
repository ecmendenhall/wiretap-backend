defmodule Wiretap.Formatters do
  import Ecto.Changeset

  alias Wiretap.Phone

  def format_phone_number(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{
          phone_number: phone_number
        }
      } ->
        {:ok, formatted_number} = Phone.format_number(phone_number)
        put_change(changeset, :phone_number, formatted_number)
      _ ->
        changeset
    end
  end

end

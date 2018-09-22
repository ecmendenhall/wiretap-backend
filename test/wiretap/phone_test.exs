defmodule Wiretap.PhoneTest do
  use ExUnit.Case

  alias Wiretap.Phone

  test "formats a valid number" do
    number = "+1 (555) 555-3226"
    assert {:ok, "+15555553226"} = Phone.format_number(number)
  end

  test "formats a number" do
    number = "not actually a number"
    assert {:error, "Invalid phone number"} = Phone.format_number(number)
  end

end

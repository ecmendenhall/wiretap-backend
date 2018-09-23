defmodule Twilio.TwilioTest do
  use ExUnit.Case

  alias Twilio

  test "constructs a call request" do
    assert {method, url, params} = Twilio.call_request("+15551234567")
    assert method == :post
    assert url == "https://api.twilio.com/2010-04-01/Accounts/test-twilio-account-sid/Calls.json"
    assert params == [{"To", "+15551234567"}, {"From", "+15207294567"}, {"Url", "https://example.com"}]
  end

end

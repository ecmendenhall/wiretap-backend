defmodule Wiretap.Calls.CallTest do
  use Wiretap.DataCase

  alias Wiretap.Calls.Call

  test "call schema" do
    call = %Call{
      recording_url: "https://example.com/recording.mp3",
      sid: "abc123"
    }
    assert call.recording_url == "https://example.com/recording.mp3"
    assert call.sid == "abc123"
  end

  describe "changeset" do
    test "creates a changeset" do
      changeset = Call.changeset(%Call{}, %{})
      assert %Ecto.Changeset{} = changeset
    end
  end


end

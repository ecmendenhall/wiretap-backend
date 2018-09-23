defmodule Twilio.Request do
  defstruct method: nil,
    resource: nil,
    params: []

  def add_param(request, name, value) do
    Map.put(
      request,
      :params,
      request.params ++ [{name, value}]
    )
  end

  def to_tuple(request) do
    {request.method, request.resource, request.params}
  end
end

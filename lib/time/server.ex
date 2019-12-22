defmodule Time.Server do

  alias Time.Api.{
    Response,
    TimeMicroservice
  }

  use GRPC.Server, service: TimeMicroservice.Service

  def get_time(request, _stream) do
    time = Response.new(timestamp: "2019.12.22 13:55:30")
    # GRPC.Server.send_reply(stream, time)
  end
end

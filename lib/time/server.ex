defmodule Time.Server do

  alias Time.Api.{
    Response,
    TimeMicroservice
  }

  use GRPC.Server, service: TimeMicroservice.Service

  @spec get_time(Time.Api.Comment.t, GRPC.Server.Stream.t) :: Time.Api.Response.t
  def get_time(_request, stream) do
    time = Response.new(timestamp: "1577015883 seconds since Jan 01 1970. (UTC)")
    GRPC.Server.send_reply(stream, time)
  end
end

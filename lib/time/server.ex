# defmodule Time.Server do

#   alias Time.Api.{
#     Comment,
#     Response,
#   }

#   use GRPC.Server, service: EnvoyRequest.Service

#   @spec verify_comment(Saga.Api.Comment.t, GRPC.Server.Stream.t) :: Saga.Api.Response.t
#   def get_time(request, _stream) do
#     Response.new(timestamp: [ Google.Protobuf.Timestamp])
#   end
# end

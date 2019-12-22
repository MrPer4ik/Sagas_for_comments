defmodule Saga.Server do

    alias Saga.Api.{
      Comment,
      Response,
      EnvoyRequest
    }

    use GRPC.Server, service: EnvoyRequest.Service

    @spec verify_comment(Saga.Api.Comment.t, GRPC.Server.Stream.t) :: Saga.Api.Response.t
    def verify_comment(request, _stream) do
      {:ok, pid} = Sagas.Comment.start_link
      Sagas.Comment.timelapse_exists(pid, request)
      Response.new(comment: [request], res_message: "Created successful!")
    end
  end

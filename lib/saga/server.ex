defmodule Saga.Server do

    alias Saga.Api.{
      Comment,
      Response,
      EnvoyRequest
    }
  
    use GRPC.Server, service: EnvoyRequest.Service
  
    @spec verify_comment(Saga.Api.Comment.t, GRPC.Server.Stream.t) :: Saga.Api.Response.t
    def verify_comment(request, _stream) do 
    #   comment = request
    #   |> Enum.map(fn %{timelapse_id: timelapse_id, body_comment: body_comment} -> 
    #     %Comment{
    #       timelapse_id: timelapse_id, 
    #       body_comment: body_comment
    #     }
    # end)

      Response.new(comment: [request], res_message: "Created successful!")
    end
  end
  
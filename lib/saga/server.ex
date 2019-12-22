defmodule Saga.Server do

    alias Saga.Api.{
      Response,
      EnvoyRequest,
      ResponseTime
    }

    use GRPC.Server, service: EnvoyRequest.Service

    @spec verify_comment(Saga.Api.Comment.t, GRPC.Server.Stream.t) :: Saga.Api.Response.t
    def verify_comment(request, stream) do
      {:ok, pid} = Sagas.Comment.start_link
      request = Saga.Api.Comment.new(timelapse_id: request.timelapse_id, author_id: request.author_id, uuid: inspect(pid), comment: request.comment)
      Sagas.Comment.timelapse_exists(pid, request)
      case Sagas.Comment.get_data(pid) do
        {:getting_time, _comment} -> Sagas.Comment.got_time(pid, request)
        {:error, message} -> {:error, message}
      end
      case Sagas.Comment.get_data(pid) do
        {:creating_comment, _comment} -> Sagas.Comment.created_comment(pid, request)
        {:error, message} -> {:error, message}
      end
     res =  case Sagas.Comment.get_data(pid) do
        {:comment_added, comment} -> {Sagas.Comment.stop(pid), comment}
        {:error, message} -> {:error, Sagas.Comment.stop(pid), message}
      end
     response = case res do
        {:ok, comment} -> Response.new(comment: [comment], res_message: "Comment created")
        {:error, :ok, message} ->  Response.new(comment: [], res_message: message)
      end

      GRPC.Server.send_reply(stream, response)
    end
    def get_time(_request, stream) do
      time = ResponseTime.new(timestamp: "1577015883 seconds since Jan 01 1970. (UTC)")
      GRPC.Server.send_reply(stream, time)
    end
  end

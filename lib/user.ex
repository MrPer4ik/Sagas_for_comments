defmodule User do

  require Logger

    alias Saga.Api.{
      EnvoyRequest
    }

    def verify_comment(requset) do
      channel = create_channel()
      {:ok, reply} = channel |> EnvoyRequest.Stub.verify_comment(requset)
      res = Enum.to_list(reply)
      |> Enum.map(&(elem(&1, 1)))

      GRPC.Stub.disconnect(channel)
      res
    end

    defp create_channel() do
      {:ok, channel} = GRPC.Stub.connect("172.17.0.3:50051")
      channel
    end
end

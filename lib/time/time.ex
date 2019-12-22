defmodule Time.Microservice do

  @moduledoc """
  Documentation for SagasForComments comes here.
  """
    require Logger

      alias Time.Api.{
        TimeMicroservice
      }

      def get_time(requset) do
        channel = create_channel()
        {:ok, reply} = channel |> TimeMicroservice.Stub.get_time(requset)
        res = Enum.to_list(reply)
      |> Enum.map(&(elem(&1, 1)))

      GRPC.Stub.disconnect(channel)
      res
      end

      defp create_channel() do
        {:ok, channel} = GRPC.Stub.connect("localhost:50051")
        channel
      end


  end

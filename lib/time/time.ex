defmodule Time.Microservice do

  @moduledoc """
  Documentation for SagasForComments comes here.
  """
    require Logger

      alias Saga.Api.{
        EnvoyRequest
      }

      # use GenStateMachine

      def verify_comment(requset) do
        channel = create_channel()
        {:ok, reply} = channel |> EnvoyRequest.Stub.verify_comment(requset)
        reply
      end

      defp create_channel() do
        {:ok, channel} = GRPC.Stub.connect("localhost:50051")
        channel
      end


  end

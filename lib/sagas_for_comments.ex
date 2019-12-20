defmodule SagasForComments do 
  
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


  # alias Mock.{Auth_service, Comments_service, Time_service, Timelapse_service}

  # def create_comment([auth_pid, timelapse_pid, time_pid, comment_pid]) do
  #   Sage.new()
  #   |> Sage.run_async(:auth, &auth_transaction/2, &auth_compensation/4)
  #   |> Sage.run_async(:timelapse, &timelapse_transaction/2, &timelapse_compensation/4)
  #   |> Sage.run(:timestamp, &time_transaction/2, &time_compensation/4)
  #   |> Sage.run(:comment, &comment_transaction/2, &comment_compensation/4)
  #   |> Sage.execute(%{
  #     comment_create: self(),
  #     auth_pid: auth_pid,
  #     timelapse_pid: timelapse_pid,
  #     time_pid: time_pid,
  #     comment_pid: comment_pid
  #   })
  # end

  # ### Authentication transaction and compensation ###

  # defp auth_transaction(_effects_so_far, %{auth_pid: auth_pid}) do
  #   Auth_service.verify(auth_pid)
  # end

  # defp auth_compensation(
  #        %Auth_service{state: :verified, verify_user: auth_pid},
  #        _effects_so_far,
  #        _error,
  #        _attrs
  #      ) do
  #   case Auth_service.cancel(auth_pid) do
  #     {:ok, _canceled_user_verification} ->
  #       :abort
  #       IO.puts "Successfully cancel user verification for auth_pid #{inspect(auth_pid)}"

  #     {:error, {:auth, :no_response}} ->
  #       Logger.error(
  #         "Cancel user verification failure for auth_pid #{inspect(auth_pid)}. Service doesn't response."
  #       )
  #       :abort
  #   end
  # end

  # defp auth_compensation(_effect_to_compensate, _effects_so_far, _error, _attrs) do
  #   :abort
  # end



  # ### Timelapse service transaction and compensation ###

  # defp timelapse_transaction(_effects_so_far, %{timelapse_pid: timelapse_pid}) do
  #   Timelapse_service.verify(timelapse_pid)
  # end

  # defp timelapse_compensation(
  #        %Timelapse_service{state: :exists, timelapse: timelapse_pid},
  #        _effects_so_far,
  #        _error,
  #        _attrs
  #      ) do
  #   case Timelapse_service.cancel(timelapse_pid) do
  #     {:ok, _canceled_tyres_order} ->
  #       IO.puts "Successful cancel timelapse verification for timelapse_pid #{inspect(timelapse_pid)}"
  #       :abort

  #       {:error, {:timelapse, :locked}} ->
  #       Logger.error(
  #         "Cancel timelapse verification failure for timelapse_pid #{inspect(timelapse_pid)}. Service is locked by another process."
  #       )

  #       {:error, {:timelapse, :no_response}} ->
  #       Logger.error(
  #         "Cancel timelapse verification failure for timelapse_pid #{inspect(timelapse_pid)}. Service doesn't response."
  #       )
  #       :abort
  #   end
  # end

  # defp timelapse_compensation(_effect_to_compensate, _effects_so_far, _error, _attrs) do
  #   :abort
  # end



  # ### Time service transaction and compensation ###

  # defp time_transaction(_effects_so_far, %{time_pid: time_pid}) do
  #   Time_service.get_ts(time_pid)
  # end

  # defp time_compensation(
  #        _effect_to_compensate,
  #        _effects_so_far,
  #        {:error, {:timestamp, :no_response}},
  #        %{timelapse_pid: timelapse_pid}
  #      ) do
  #   Logger.error(
  #     "Getting timestamp failure for timelapse_pid #{inspect(timelapse_pid)}. Service doesn't response."
  #   )
  #   {:retry, retry_limit: 3}
  # end

  # defp time_compensation(_effect_to_compensate, _effects_so_far, _error, _attrs) do
  #   :abort
  # end



  # ### Comment transaction and compensation ###

  # defp comment_transaction(_effects_so_far, %{comment_pid: comment_pid}) do
  #   Comments_service.create_comment(comment_pid)
  # end

  # defp comment_compensation(
  #       _effects_to_compensate,
  #       _effects_so_far,
  #       {:error, {:comment, :exists}},
  #       %{timelapse_pid: timelapse_pid}
  #       ) do
  #   Logger.error(
  #     "Creating comment failed for timelapse #{inspect(timelapse_pid)}. This comment has already existed!"
  #   )
  #   :abort
  # end

  # defp comment_compensation(
  #       _effects_to_compensate,
  #       _effects_so_far,
  #       {:error, {:comment, :locked}},
  #       %{timelapse_pid: timelapse_pid}
  #       ) do
  #   Logger.error(
  #     "Creating comment failed for timelapse #{inspect(timelapse_pid)}. Service is locked by another process. Retrying..."
  #   )
  #   {:retry, retry_limit: 3}
  # end

  # defp comment_compensation(
  #       _effects_to_compensate,
  #       _effects_so_far,
  #       {:error, {:comment, :no_response}},
  #       %{timelapse_pid: timelapse_pid}
  #       ) do
  #   Logger.error(
  #     "Creating comment failed for timelapse #{inspect(timelapse_pid)}. Service doesn't response. Retrying..."
  #   )
  #   {:retry, retry_limit: 3}
  # end

  # defp comment_compensation(_effect_to_compensate, _effects_so_far, _error, _attrs) do
  #   :abort
  # end
end

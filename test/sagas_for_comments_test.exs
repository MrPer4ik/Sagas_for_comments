defmodule SagasForCommentsTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Mock.{Server, Auth_service, Comments_service, Time_service, Timelapse_service}

  @list_auth_verify_responses [{:ok, :verified}, {:error, :rejected}, {:error, :no_response}]
  @list_auth_cancel_responses [{:ok, :canceled}, {:error, :no_response}]
  @list_timelapse_verify_responses [{:ok, :exists}, {:error, :deleted}, {:error, :locked}, {:error, :no_response}]
  @list_timelapse_cancel_responses [{:ok, :canceled}, {:error, :locked}, {:error, :no_response}]
  @list_time_responses [{:ok, :got}, {:error, :no_response}]
  @list_comment_create_responses [{:ok, :created}, {:error, :exists}, {:error, :locked}, {:error, :no_response}]

  property "check comments saga" do
    check all auth_verify_responses <- generate_responses_list(@list_auth_verify_responses),
              auth_cancel_responses <- generate_responses_list(@list_auth_cancel_responses),
              timelapse_verify_responses <- generate_responses_list(@list_timelapse_verify_responses),
              timelapse_cancel_responses <- generate_responses_list(@list_timelapse_cancel_responses),
              time_responses <- generate_responses_list(@list_time_responses),
              comment_create_responses <- generate_responses_list(@list_comment_create_responses),
              max_runs: 10 do
      {:ok, auth_pid} =
        Server.start_link(%{verification: auth_verify_responses, cancel: auth_cancel_responses})

      {:ok, timelapse_pid} =
        Server.start_link(%{verify: timelapse_verify_responses, cancel: timelapse_cancel_responses})

      {:ok, time_pid} = Server.start_link(%{get_ts: time_responses})

      {:ok, comment_pid} = Server.start_link(%{create_comment: comment_create_responses})

      pids = [auth_pid, timelapse_pid, time_pid, comment_pid]

      pids
      |> SagasForComments.create_comment()
      |> check_result(pids)
    end
  end

  defp check_result(
         {:ok, _result,
          %{
            auth: %Auth_service{state: :verified, verify_user: verify_user},
            timelapse: %Timelapse_service{state: :exist, timelapse: timelapse},
            timestamp: %Time_service{get_timestamp: get_timestamp, state: :got},
            comment: %Comments_service{comment: comment, state: :created}
          }},
          [auth_pid, timelapse_pid, time_pid, comment_pid]
       ) do
    assert verify_user == auth_pid
    assert timelapse == timelapse_pid
    assert get_timestamp == time_pid
    assert comment == comment_pid
  end

  defp check_result({:error, _error}, pids) do
    for pid <- pids do
      assert Server.get_last_response(pid) in [
               {:error, :no_response},
               {:error, :exists},
               {:ok, :canceled},
               {:error, :locked},
               {:error, :failed},
               {:error, :rejected},
               {:ok, :got},
               {:error, :deleted},
               :not_called
             ]
    end
  end

  defp generate_responses_list(responses) do
    responses
    |> StreamData.member_of()
    |> StreamData.list_of(length: 1)
  end
end

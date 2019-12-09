defmodule SagasForCommentsTest do
    use ExUnit.Case
    use ExUnitProperties
    alias Mock.{Server, Auth_service, Comments_service, Time_service, Timelapse_service}
  
    @auth_verify_responses [{:ok, :verified}, {:error, :rejected}, {:error, :no_response}]
    @auth_cancel_responses [{:ok, :canceled}, {:error, :no_response}]
    @timelapse_verify_responses [{:ok, :exists}, {:error, :deleted}, {:error, :locked}, {:error, :no_response}]
    @timelapse_cancel_responses [{:ok, :canceled}, {:error, :locked}, {:error, :no_response}]
    @time_responses [{:ok, :got}, {:error, :no_response}]
    @comment_create_responses [{:ok, :created}, {:error, :exists}, {:error, :locked}, {:error, :no_response}]
  
    property "check comments saga" do
      check all auth_verify_responses <- generate_responses_list(@auth_verify_responses),
                auth_cancel_responses <- generate_responses_list(@auth_cancel_responses),
                timelapse_verify_responses <- generate_responses_list(@timelapse_verify_responses),
                timelapse_cancel_responses <- generate_responses_list(@timelapse_cancel_responses),
                time_responses <- generate_responses_list(@time_responses),
                comment_create_responses <- generate_responses_list(@comment_create_responses),
                max_runs: 100 do
        {:ok, auth_pid} =
          Server.start_link(%{verify: auth_verify_responses, cancel: auth_cancel_responses})
  
        {:ok, timelapse_pid} =
          Server.start_link(%{verify: timelapse_verify_responses, cancel: timelapse_cancel_responses})
  
        {:ok, time_pid} = Server.start_link(%{get_ts: time_responses})
  
        {:ok, comment_pid} = Server.start_link(%{create_comment: comment_create_responses})
  
        pids = [auth_pid, timelapse_pid, time_pid, comment_pid]
  
        pids
        |> SagasForComments.create_comment()
      end
    end
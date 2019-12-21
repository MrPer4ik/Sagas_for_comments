defmodule Fsm.States do

    use GenStateMachine, callback_mode: :state_functions


    def start_creating_comment(:cast, {:verify_timelapse, comment}, _loop_data) do
        {:next_state, :verification_timelapse, comment}
    end

    def verification_timelapse(:cast, {:timelapse_exists, comment}, _loop_data) do
        {:next_state, :getting_time, comment}
    end

    def verification_timelapse(:cast, {:timelapse_not_exists, comment}, _loop_data) do
        {:next_state, :error, comment}
    end

    def getting_time(:cast, {:got_time, comment}, _loop_data) do
        {:next_state, :creating_comment, comment}
    end

    def getting_time(:cast, {:not_got_time, comment}, _loop_data) do
        {:next_state, :error, comment}
    end

    def creating_comment(:cast, {:created_comment, comment}, _loop_data) do
        {:next_state, :return_acknowledge, comment}
    end

    def creating_comment(:cast, {:not_created_comment, comment}, _loop_data) do
        {:next_state, :error, comment}
    end

    def handle_sync_event(:cast, {:stop}, _from, _state, _loop_date) do
        {:stop, :normal, []}
    end

    def terminate(_reason, _statem_name, _loop_data) do
        :ok
    end
    
end
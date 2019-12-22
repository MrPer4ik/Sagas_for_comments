defmodule Sagas.Comment do

    use GenStateMachine, callback_mode: :state_functions

    # Events
    def start_link do
        GenStateMachine.start_link(__MODULE__, {:verification_timelapse, {:verification_timelapse, []}})
    end

    def timelapse_exists(pid, comment) do
        GenStateMachine.cast(pid, {:timelapse_exists, comment})
    end

    def got_time(pid, comment) do
        GenStateMachine.cast(pid, {:got_time, comment})
    end

    def created_comment(pid, comment) do
        GenStateMachine.cast(pid, {:created_comment, comment})
    end

    def get_data(pid) do
        GenStateMachine.call(pid, :get_data)
    end

    def stop(pid) do
        GenStateMachine.stop(pid)
    end


    def verification_timelapse(:cast, {:timelapse_exists, comment}, _loop_data) do
        timelapse = %{timelaspe_id: comment.timelapse_id}
        timelapse_json = Poison.encode!(timelapse)
        KafkaEx.produce(Kafka.Topics.timelapse_verification, 0, timelapse_json)
        res = answer_timelapse()
        case res do
            "Timelapse verified" -> {:next_state, :getting_time, {:getting_time, comment}}
            "Timelapse isn`t verified" -> {:next_state, :error, {:error, "Timelapse isn`t verified"}}
            _ -> {:next_state, :error, {:error, "Unrecognised response"}}
        end
    end


    def answer_timelapse do
        KafkaEx.produce(Kafka.Topics.a_timelapse_verification, 0 , "{\"answer\": \"Timelapse verified\"}") #mock answer
        #KafkaEx.produce(Kafka.Topics.a_timelapse_verification, 0 , "{\"answer\": \"Timelapse isn`t verified\"}")
        res = KafkaEx.fetch(Kafka.Topics.a_timelapse_verification, 0)
        answer = List.to_tuple(List.first(List.first(res).partitions).message_set)
        size = tuple_size(answer)
        cond do
          size == 0 -> answer_timelapse()
          size >= 1 -> answer_timelapse(answer)
        end
    end

    def answer_timelapse(answer) do
        value = elem(answer, 0)
        decode = Poison.decode!(value.value, as: %{answer: answer})
        decode["answer"]
    end

    def creating_comment(:cast, {:created_comment, comment}, {:creating_comment, comment}) do
        result = Poison.encode!(comment)
        KafkaEx.produce(Kafka.Topics.create_comment, 0, result)
        res = answer_comment()
        case res do
            "Comment created" -> {:next_state, :comment_added, {:comment_added, comment}}
            "Comment isn`t created" -> {:next_state, :error, {:error, "Comment isn`t created"}}
            _ -> {:next_state, :error, {:error, "Unrecognised response"}}
        end
    end

    def answer_comment do
        KafkaEx.produce(Kafka.Topics.a_create_comment, 0 , "{\"answer\": \"Comment created\"}") # mock answer
        # KafkaEx.produce(Kafka.Topics.a_create_comment, 0 , "{\"answer\": \"\"}")
        res = KafkaEx.fetch(Kafka.Topics.a_create_comment, 0)
        answer = List.to_tuple(List.first(List.first(res).partitions).message_set)
        size = tuple_size(answer)
        cond do
          size == 0 -> answer_comment()
          size >= 1 -> answer_comment(answer)
        end
    end

    def answer_comment (answer) do
        value = elem(answer, 0)
        decode = Poison.decode!(value.value, as: %{answer: answer})
        decode["answer"]
    end

    # States
    def verification_timelapse(event_type, event_content, data) do
        handle_event(event_type, event_content, data)
    end

    def getting_time(:cast, {:got_time, comment},  {:getting_time, comment}) do
        {:next_state, :creating_comment, {:creating_comment, comment}}
    end

    def getting_time(event_type, event_content, data) do
        handle_event(event_type, event_content, data)
    end

    def creating_comment(event_type, event_content, data) do
        handle_event(event_type, event_content, data)
    end

    def comment_added(event_type, event_content, data) do
        handle_event(event_type, event_content, data)
    end

    def error(event_type, event_content, data) do
        handle_event(event_type, event_content, data)
    end

    def handle_event({:call, from}, :get_data, data) do
        {:keep_state_and_data, [{:reply, from, data}]}
    end

end

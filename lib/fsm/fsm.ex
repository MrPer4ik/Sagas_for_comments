defmodule Sagas.Comment do

    use GenStateMachine, callback_mode: :state_functions

    #API Client
    def start_link do
        GenStateMachine.start_link(__MODULE__, {:verification_timelapse, []})
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

    def stop(pid) do
        GenStateMachine.stop(pid)
    end


    def verification_timelapse(:cast, {:timelapse_exists, comment}, _loop_data) do
        timelapse = %{timelaspe_id: comment.timelapse_id}
        timelapse_json = Poison.encode!(timelapse)
        KafkaEx.produce(Kafka.Topics.timelapse_verification, 0, timelapse_json)
        res = answer_timelapse()
        case res do
            "ok" -> {:next_state, :getting_time, {:getting_time, comment}}
            "no" -> {:next_state, :error, {:error, comment}}
        end
        # {:next_state, :getting_time, {:getting_time, comment}}
    end

    def answer_timelapse do
        KafkaEx.produce(Kafka.Topics.a_timelapse_verification, 0 , "{\"answer\": \"ok\"}")
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


    def getting_time(:cast, {:got_time, comment}, _loop_data) do
        {:next_state, :creating_comment, comment}
    end

    # def getting_time(:cast, {:not_got_time, comment}, _loop_data) do
    #     {:next_state, :error, comment}
    # end

    def creating_comment(:cast, {:created_comment, comment}, loop_data) do
        result = Poison.encode!(loop_data)
        KafkaEx.produce(Kafka.Topics.create_comment, 0, result)
        res = answer_comment()
        case res do
            "ok" -> {:next_state, :comment_added, {:comment_added, comment}}
            "no" -> {:next_state, :error, {:error, comment}}
        end
    end

    def answer_comment do
        KafkaEx.produce(Kafka.Topics.a_create_comment, 0 , "{\"answer\": \"ok\"}")
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

end

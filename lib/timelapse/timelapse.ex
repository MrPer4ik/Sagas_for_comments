# defmodule Timelapse do
#     def answer_timelapse(pid) do
#         KafkaEx.produce(Kafka.Topics.timelapse_verification, 0 , "{\"answer\": \"ok\"}")
#         res = KafkaEx.fetch(Kafka.Topics.timelapse_verification, 0)
#         answer = List.to_tuple(List.first(List.first(res).partitions).message_set)
#         size = tuple_size(answer)
#         cond do
#           size == 0 -> answer_authentication(pid)
#           size >= 1 -> answer_authentication(pid, answer)
#         end
#       end
    
#       def answer_timelapse(pid, answer) do
#         value = elem(answer, 0)
#         decode = Poison.decode!(value.value, as: %{answer: answer})
#         case decode["answer"] do
#             "ok" -> Sagas.Comment.timelapse_not_exists(pid,)
#             "no" -> Sagas.Comment.timelapse_not_exists(pid,)
#             end
#       end
# end
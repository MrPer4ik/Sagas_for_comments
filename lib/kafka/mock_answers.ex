defmodule Kafka.Mock_answers do

  def produce(topic, value) do
    KafkaEx.produce(topic, 0, value)
  end

end

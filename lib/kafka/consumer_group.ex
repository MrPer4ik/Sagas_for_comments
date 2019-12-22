defmodule ConsumerGroup do
    use Application

    def start(_type, _args) do
      import Supervisor.Spec

      consumer_group_opts = [
        heartbeat_interval: 1_000,
        commit_interval: 1_000
      ]

      gen_consumer_impl = ExampleGenConsumer
      consumer_group_name = "example_group"
      topic_names = ["example_topic"]

      children = [
        supervisor(
          KafkaEx.ConsumerGroup,
          [gen_consumer_impl, consumer_group_name, topic_names, consumer_group_opts]
        )
      ]

      Supervisor.start_link(children, strategy: :one_for_one)
    end
end

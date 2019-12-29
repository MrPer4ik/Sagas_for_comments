defmodule SagasForComments.MixProject do
  use Mix.Project

  def project do
    [
      app: :sagas_for_comments,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Saga.Application, []},
      extra_applications: [:logger],
      applications: [
        :kafka_ex, :grpc, :gen_state_machine, :poison
      ]
    ]
  end

  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:kafka_ex, "~> 0.9.0"},
      {:gen_state_machine, "~> 2.0"},
      {:grpc, github: "elixir-grpc/grpc"},
      {:poison, "~> 3.1"}
    ]
  end
end

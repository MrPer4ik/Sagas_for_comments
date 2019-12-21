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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Saga.Application, []},
      extra_applications: [:logger], 
      applications: [
        :kafka_ex,
        :snappy # if using snappy compression
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:stream_data, "~> 0.1", only: :test},
      {:sage, "~> 0.4.0"},
      {:kafka_ex, "~> 0.9.0"},
      # if using snappy compression
      {:snappy, git: "https://github.com/fdmanana/snappy-erlang-nif"}, 
      {:gen_state_machine, "~> 2.0"},
      {:grpc, github: "elixir-grpc/grpc"},
      {:poison, "~> 3.1"}
    ]
  end
end

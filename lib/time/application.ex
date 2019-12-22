import Supervisor.Spec

defmodule Time.Microservice.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  run Time.Server
end

defmodule Time.Microservice.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Saga.Worker.start_link(arg)
      # {Saga.Worker, arg}
      supervisor(GRPC.Server.Supervisor, [{Time.Microservice.Endpoint, 50051}])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Time.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

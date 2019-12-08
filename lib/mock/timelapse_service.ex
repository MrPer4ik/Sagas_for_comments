defmodule Mock.Timelapse_service do
    defstruct timelapse_exist: nil, state: nil
  
    alias __MODULE__
  
    def verify(pid) do
      case Mock.Server.request(pid, :verify) do
        {:ok, :exists} -> {:ok, %Timelapse_service{timelapse: pid, state: :exists}}
        {:error, :deleted} -> {:error, {:timelapse, :deleted}}
        {:error, :locked} -> {:error, {:timelapse, :locked}}
        {:error, :no_response} -> {:error, {:service, :no_response}}
      end
    end
  
    def cancel(pid) do
      case Mock.Server.request(pid, :cancel) do
        {:ok, :canceled} -> {:ok, %Timelapse_service{timelapse: pid, state: :cancelled}}
        {:error, :no_response} -> {:error, {:service, :no_response}}
      end
    end
  end
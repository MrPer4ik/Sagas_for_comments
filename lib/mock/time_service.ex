defmodule Mock.Time_service do

    defstruct get_timestamp: nil, state: nil
  
    alias __MODULE__
  
    def get_ts(pid) do
      case Mock.Server.request(pid, :get_ts) do
        {:ok, :got} -> {:ok, %Time_service{timestamp: pid, state: :got}}
        {:error, :no_response} -> {:error, {:service, :no_response}}
      end
    end
  
    # def cancel(pid) do
    #   case Mock.Server.request(pid, :cancel) do
    #     {:ok, :deleted} -> {:ok, %Time_service{timestamp: pid, state: :deleted}}
    #     {:error, :no_response} -> {:error, {:service, :no_response}}
    #   end
    # end
  end
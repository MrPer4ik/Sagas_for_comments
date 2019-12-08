defmodule Mock.Auth_service do

    defstruct verify_user: nil, state: nil
  
    alias __MODULE__
  
    def verify(pid) do
      case Mock.Server.request(pid, :verification) do
        {:ok, :verified} -> {:ok, %Auth_service{verify_user: pid, state: :verified}}
        {:error, :rejected} -> {:error, {:user, :rejected}}
        {:error, :no_response} -> {:error, {:service, :no_response}}
      end
    end
  
    def cancel(pid) do
      case Mock.Server.request(pid, :cancel) do
        {:ok, :canceled} -> {:ok, %Auth_service{verify_user: pid, state: :cancelled}}
        {:error, :no_response} -> {:error, {:service, :no_response}}
      end
    end
  end
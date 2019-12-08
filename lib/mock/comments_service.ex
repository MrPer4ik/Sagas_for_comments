defmodule Mock.Comments_service do
    defstruct comment: nil, state: nil
  
    alias __MODULE__
  
    def create_comment(pid) do
      case Mock.Server.request(pid, :create_comment) do
        {:ok, :created} -> {:ok, %Comments_service{comment: pid, state: :created}}
        {:error, :exists} -> {:error, {:comment, :exists}}
        {:error, :locked} -> {:error, {:comment, :locked}}
        {:error, :no_response} -> {:error, {:comment, :no_response}}
      end
    end
  
    # def delete_comment(pid) do
    #   case Mock.Server.request(pid, :delete) do
    #     {:ok, :deleted} -> {:ok, %Comments_service{comment: pid, state: :deleted}}
    #     {:error, :locked} -> {:error, {:service, :locked}}
    #     {:error, :no_response} -> {:error, {:service, :no_response}}
    #   end
    # end
  end
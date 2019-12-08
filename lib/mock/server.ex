defmodule Mock.Server do
    @moduledoc """
    Generic mock server that keeps track of external services responses.
    Each external service initialize one of those servers.
    """
    use GenServer

    # API

    def start_link(responses) do
      GenServer.start_link(__MODULE__, responses)
    end
  
    def request(pid, type) do
      GenServer.call(pid, {:request, type})
    end
  
    def get_last_response(pid) do
      GenServer.call(pid, :get_last_response)
    end
end
  
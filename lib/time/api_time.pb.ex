defmodule Time.Api.MyMessage do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Time.Api.Comment do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          timelapse_id: String.t(),
          body_comment: String.t(),
          comment_id: String.t(),
          timestamp: String.t()
        }
  defstruct [:timelapse_id, :body_comment, :comment_id, :timestamp]

  field :timelapse_id, 1, type: :string
  field :body_comment, 2, type: :string
  field :comment_id, 3, type: :string
  field :timestamp, 4, type: :string
end

defmodule Time.Api.Response do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          timestamp: String.t()
        }
  defstruct [:timestamp]

  field :timestamp, 1, type: :string
end

defmodule Time.Api.TimeMicroservice.Service do
  @moduledoc false
  use GRPC.Service, name: "time.api.TimeMicroservice"

  rpc :get_time, Time.Api.Comment, stream(Time.Api.Response)
end

defmodule Time.Api.TimeMicroservice.Stub do
  @moduledoc false
  use GRPC.Stub, service: Time.Api.TimeMicroservice.Service
end

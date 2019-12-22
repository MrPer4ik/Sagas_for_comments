defmodule Saga.Api.Comment do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          uuid: String.t(),
          timelapse_id: String.t(),
          author_id: String.t(),
          comment: String.t(),
          timestamp: String.t()
        }
  defstruct [:uuid, :timelapse_id, :author_id, :comment, :timestamp]

  field :uuid, 1, type: :string
  field :timelapse_id, 2, type: :string
  field :author_id, 3, type: :string
  field :comment, 4, type: :string
  field :timestamp, 5, type: :string
end

defmodule Saga.Api.Response do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          comment: [Saga.Api.Comment.t()],
          res_message: String.t()
        }
  defstruct [:comment, :res_message]

  field :comment, 1, repeated: true, type: Saga.Api.Comment
  field :res_message, 2, type: :string
end

defmodule Saga.Api.EnvoyRequest.Service do
  @moduledoc false
  use GRPC.Service, name: "saga.api.EnvoyRequest"

  rpc :VerifyComment, Saga.Api.Comment, stream(Saga.Api.Response)
end

defmodule Saga.Api.EnvoyRequest.Stub do
  @moduledoc false
  use GRPC.Stub, service: Saga.Api.EnvoyRequest.Service
end

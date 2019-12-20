defmodule Saga.Api.Comment do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          timelapse_id: String.t(),
          body_comment: String.t()
        }
  defstruct [:timelapse_id, :body_comment]

  field :timelapse_id, 1, type: :string
  field :body_comment, 2, type: :string
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

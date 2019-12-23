# SagasForComments

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sagas_for_comments` to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [
    {:sagas_for_comments, "~> 0.1.0"}
  ]
end
```

To test working sagas you can run this command in prompt:
```prompt
> mix test
```

To run test sagas in Docker you need to run following commands in prompt (with `sudo` before it if you haven`t got configured Docker):
```prompt
> docker build -t saga_comments .
```

And after it builds Docker you should run (also with `sudo` if you haven`t got Docker configs):
```prompt
> docker run saga_comments
```
defmodule SagasForCommentsTest do
  use ExUnit.Case
  doctest SagasForComments

  test "greets the world" do
    assert SagasForComments.hello() == :world
  end
end

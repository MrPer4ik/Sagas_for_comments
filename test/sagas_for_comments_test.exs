defmodule SagasForCommentsTest do
  use ExUnit.Case

  require Logger

  test "everything is ok" do
    comment = Saga.Api.Comment.new(timelapse_id: "1", comment: "lhablrhaeirnaejrnaeornlehab", author_id: "392")
    Kafka.Mock_answers.produce(Kafka.Topics.a_timelapse_verification, "{\"answer\": \"Timelapse verified\"}")
    Kafka.Mock_answers.produce(Kafka.Topics.a_create_comment, "{\"answer\": \"Comment created\"}")
    res = User.verify_comment(comment)
    answer = elem(List.to_tuple(res), 0).res_message
    Logger.debug(answer)
    assert answer == "Comment created"
  end

  test "timelapse verification fail" do
    comment = Saga.Api.Comment.new(timelapse_id: "1", comment: "lhablrhaeirnaejrnaeornlehab", author_id: "392")
    Kafka.Mock_answers.produce(Kafka.Topics.a_timelapse_verification, "{\"answer\": \"Timelapse isn`t verified\"}")
    res = User.verify_comment(comment)
    answer = elem(List.to_tuple(res), 0).res_message
    Logger.debug(answer)
    assert answer == "Timelapse isn`t verified"
  end

  test "comment creation fail" do
    comment = Saga.Api.Comment.new(timelapse_id: "1", comment: "lhablrhaeirnaejrnaeornlehab", author_id: "392")
    Kafka.Mock_answers.produce(Kafka.Topics.a_timelapse_verification, "{\"answer\": \"Timelapse verified\"}")
    Kafka.Mock_answers.produce(Kafka.Topics.a_create_comment, "{\"answer\": \"Comment isn`t created\"}")
    res = User.verify_comment(comment)
    answer = elem(List.to_tuple(res), 0).res_message
    Logger.debug(answer)
    assert answer == "Comment isn`t created"
  end

  test "everything failed" do
    comment = Saga.Api.Comment.new(timelapse_id: "1", comment: "lhablrhaeirnaejrnaeornlehab", author_id: "392")
    Kafka.Mock_answers.produce(Kafka.Topics.a_timelapse_verification, "{\"answer\": \"Timelapse isn`t verified\"}")
    res = User.verify_comment(comment)
    answer = elem(List.to_tuple(res), 0).res_message
    Logger.debug(answer)
    assert answer == "Timelapse isn`t verified"
  end

  test "no response from timelapse" do
    comment = Saga.Api.Comment.new(timelapse_id: "1", comment: "lhablrhaeirnaejrnaeornlehab", author_id: "392")
    Kafka.Mock_answers.produce(Kafka.Topics.a_timelapse_verification, "{\"answer\": \"No response\"}")
    res = User.verify_comment(comment)
    answer = elem(List.to_tuple(res), 0).res_message
    Logger.debug(answer)
    assert answer == "Unrecognised response"
  end

  test "no response from comment" do
    comment = Saga.Api.Comment.new(timelapse_id: "1", comment: "lhablrhaeirnaejrnaeornlehab", author_id: "392")
    Kafka.Mock_answers.produce(Kafka.Topics.a_timelapse_verification, "{\"answer\": \"Timelapse verified\"}")
    Kafka.Mock_answers.produce(Kafka.Topics.a_create_comment, "{\"answer\": \"No response\"}")
    res = User.verify_comment(comment)
    answer = elem(List.to_tuple(res), 0).res_message
    Logger.debug(answer)
    assert answer == "Unrecognised response"
  end

end

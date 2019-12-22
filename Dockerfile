FROM elixir:1.9.4 as builder

ENV VERSION 0.1.0

WORKDIR /opt/saga-comments/
COPY . /opt/saga-comments/

EXPOSE 50051 9092

RUN mix local.hex --force && mix local.rebar --force
RUN MIX_ENV=prod mix do deps.get --only prod, deps.compile --force
RUN mix deps.clean mime --build 



RUN mix deps.get && mix deps.compile

# ENTRYPOINT ["iex", "-S", "mix"]

CMD [ "mix", "run" ]

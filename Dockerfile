FROM gcr.io/turn-services/turnio-conversation-claiming:qa-latest as build

# prepare build dir
WORKDIR /app

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY VERSION VERSION
RUN mix do deps.get, deps.compile

COPY priv priv

# compile and build release
COPY lib lib
COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/conv_claim ./

ENV HOME=/app

CMD ["bin/conv_claim", "start"]

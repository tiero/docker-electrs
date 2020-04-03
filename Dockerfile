FROM rust:1.34.0-slim AS builder

ARG TAG=v0.8.3

RUN apt-get update
RUN apt-get install -y clang cmake git
RUN apt-get install -y libsnappy-dev

RUN git clone https://github.com/romanz/electrs && cd electrs && git checkout tags/${TAG} -b ${TAG}
WORKDIR /electrs
RUN cargo build --release --bin electrs


FROM debian:stable-slim


WORKDIR /app
COPY --from=builder /electrs/target/release/electrs /app/electrs

# Electrum RPC
EXPOSE 50001
# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

ENTRYPOINT ["/app/electrs"]
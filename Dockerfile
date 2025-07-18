FROM lukemathwalker/cargo-chef:latest-rust-1 AS chef
WORKDIR /labo0

FROM chef AS planner
COPY . .
RUN cargo chef prepare

FROM chef AS builder
RUN apt-get update && apt-get install -y libpq-dev libssl-dev pkg-config build-essential
COPY --from=planner /labo0/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release --bin Labo1


FROM ubuntu:latest AS runtime
RUN apt-get update && apt-get install -y libpq5 libssl3
WORKDIR /labo0
COPY --from=builder /labo0/target/release/Labo1 /usr/local/bin
ENTRYPOINT ["/usr/local/bin/Labo1"]
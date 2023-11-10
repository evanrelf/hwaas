FROM rust:1.73.0 as builder

WORKDIR /app

# Build dependencies
COPY Cargo.toml Cargo.lock /app
RUN \
  mkdir src && \
  echo 'fn main() {}' > src/main.rs && \
  cargo build --release && \
  rm -rf src

# Build app
COPY src /app/src
RUN \
  touch src/main.rs && \
  cargo build --bins --release

FROM gcr.io/distroless/cc-debian12
COPY --from=builder /app/target/release/hwaas /usr/local/bin/
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/hwaas"]

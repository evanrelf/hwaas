FROM rust:1.73.0-alpine as builder
RUN apk add --no-cache musl-dev pkgconf
ENV SYSROOT=/dummy
WORKDIR /workdir
COPY . .
RUN cargo build --bins --release

FROM scratch
COPY --from=builder  /workdir/target/release/hwaas /
EXPOSE 8080
CMD ["./hwaas"]

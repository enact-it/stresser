FROM golang:tip-alpine3.24@sha256:2b8d0f88d4569610d129a775c9b4d4c571db2e173c77a40f864f0ba1b00225f7 AS builder

WORKDIR /app
COPY main.go go.mod go.sum ./

RUN go mod download
RUN go build -o stresser .

FROM scratch

LABEL org.opencontainers.image.source=https://github.com/enact-it/stresser
LABEL org.opencontainers.image.description="Utility to test resource consumption"
LABEL org.opencontainers.image.licenses=MIT


WORKDIR /app
COPY --from=builder /app/stresser .

ENTRYPOINT ["./stresser"]

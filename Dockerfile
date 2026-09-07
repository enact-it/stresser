FROM golang:tip-alpine3.24@sha256:2f7efa5a005828a27e3249366f074c8edcab11bf62bd95d573532568ba14766b AS builder

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

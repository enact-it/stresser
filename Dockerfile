FROM golang:tip-alpine3.24@sha256:44391f36c74531fec7cce36984c878b0e35206796269d6c5cd2f2c8338669fc0 AS builder

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

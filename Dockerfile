FROM golang:tip-alpine3.22 AS builder

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

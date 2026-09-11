FROM golang:tip-alpine3.24@sha256:9d9ed5461a1aec9e7be297059579cc6c015bd641fb71381a1774ec6940cca5a4 AS builder

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

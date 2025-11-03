FROM golang:tip-alpine3.22 AS builder

WORKDIR /app

COPY main.go go.mod go.sum ./

RUN go mod download

RUN go build -o stresser .

FROM scratch

WORKDIR /app

COPY --from=builder /app/stresser .

ENTRYPOINT ["./stresser"]



FROM golang:1.24-alpine AS builder

WORKDIR /app

RUN go install github.com/air-verse/air@latest

COPY go.mod ./

RUN go mod download

COPY . .

EXPOSE 8080 6060

CMD ["air", "-c", ".air.toml"]
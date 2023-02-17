FROM golang:1-alpine AS builder

WORKDIR /go/src/github.com/hello-world

RUN apk add --update git

COPY . .
RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o app .

FROM alpine
EXPOSE 8081

COPY --from=builder /go/src/github.com/hello-world/app .

ENTRYPOINT ./app


# docker build --rm -t hello-world .
# curl localhost:8081
FROM golang:1.25.3-alpine AS base
WORKDIR /go/src/go-onsite-app

ENV GO111MODULE="on"
ENV GOOS="linux"
ENV CGO_ENABLED=0

# System dependencies
RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    git \
    && update-ca-certificates

# Hot reloading mod

RUN go install github.com/air-verse/air@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
EXPOSE 8000
EXPOSE 2345

ENTRYPOINT ["air"]

### Executable builder
FROM base AS builder
WORKDIR /go/src/go-onsite-app

# Application dependencies
COPY . /go/src/go-onsite-app
RUN go mod download \
    && go mod verify

ENTRYPOINT ["./cmd.sh"]
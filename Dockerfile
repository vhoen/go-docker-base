FROM golang:1.23-alpine AS base
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
    
RUN go install github.com/go-delve/delve/cmd/dlv@latest
EXPOSE 8000
EXPOSE 2345

COPY . /go/src/go-onsite-app
RUN go mod download \
    && go mod verify


ENTRYPOINT ["./cmd.sh"]

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

# Hot reloading and debugging tools
RUN go install github.com/air-verse/air@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest

EXPOSE 8000
EXPOSE 2345

### Development stage with Air and Delve
FROM base AS dev
WORKDIR /go/src/go-onsite-app

# Copy source code
COPY . /go/src/go-onsite-app

# Download dependencies
RUN go mod download && go mod verify

# Copy Air config
COPY .air.toml .air.toml

CMD ["air"]

### Production builder
FROM base AS builder
WORKDIR /go/src/go-onsite-app

COPY . /go/src/go-onsite-app
RUN go mod download && go mod verify
RUN go build -o go-onsite-app -a .

FROM alpine:latest AS production
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/go-onsite-app/go-onsite-app .
EXPOSE 8000
CMD ["./go-onsite-app"]
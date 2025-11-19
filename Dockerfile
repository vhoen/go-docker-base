# ---------- Base dev image ----------
FROM golang:1.25.3-alpine

WORKDIR /app

ENV GO111MODULE=on \
    GOOS=linux \
    CGO_ENABLED=0 \
    PATH=$PATH:/go/bin

# System dependencies
RUN apk update && apk add --no-cache \
    ca-certificates \
    git \
    bash \
    libc6-compat \
    && update-ca-certificates

# Install Air (hot reload) and Delve (debugger)
RUN go install github.com/air-verse/air@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Expose default ports: web + debugger
EXPOSE 8000 2345

# Copy project (will be mounted in docker-compose, so optional)
COPY . /app

# Entrypoint: wrapper script that runs Air + Delve
COPY start-dev.sh /app/start-dev.sh
RUN chmod +x /app/start-dev.sh

CMD ["/app/start-dev.sh"]

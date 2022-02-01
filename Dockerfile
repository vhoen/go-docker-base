# syntax=docker/dockerfile:1
FROM alpine:latest

RUN echo "alias ll='ls -alF'" >> ~/.bashrc
RUN echo "alias la='ls A'" >> ~/.bashrc

RUN apk update
RUN apk add bash
RUN apk add vim
RUN apk add --no-cache git make musl-dev go


# RUN wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
# RUN tar -xzf go1.17.3.linux-amd64.tar.gz
# RUN mv go /usr/local 
# RUN rm go1.17.3.linux-amd64.tar.gz

# USER root

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPRIVATE=*.pv-cp.net

ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# Set the Current Working Directory inside the container
WORKDIR /go/src/go-onsite-app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Copy the code into the container
COPY . .


# Export necessary port
EXPOSE 8000

# # Command to run when starting the container
CMD ["go", "run", "main.go", "-config", "/go/src/go-onsite-app/parameters/parameters.json", "-debug=Debug"]
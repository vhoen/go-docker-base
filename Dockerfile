# syntax=docker/dockerfile:1
# https://www.reddit.com/r/docker/comments/i0wu32/how_can_i_debug_golang_running_in_docker_with/
FROM alpine:3.17

RUN echo "alias ll='ls -alF'" >> ~/.bashrc
RUN echo "alias la='ls A'" >> ~/.bashrc

RUN apk update
RUN apk add --no-cache git bash vim curl make musl-dev go tzdata

# RUN apk add --no-cache \
#         wkhtmltopdf \
#         xvfb \
#         ttf-dejavu ttf-droid ttf-freefont ttf-liberation

# RUN ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf;
# RUN chmod +x /usr/local/bin/wkhtmltopdf;

ENV TZ Europe/Paris
RUN apk add --no-cache alpine-conf &&\
    setup-timezone -z $TZ
    
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPRIVATE=*.pv-cp.net

ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# Installs godoc
RUN go install -v golang.org/x/tools/cmd/godoc@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Set the Current Working Directory inside the container
WORKDIR /go/src/go-onsite-app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Copy the code into the container
COPY . .


# Export necessary port
EXPOSE 8000

# Command to run when starting the containerst
CMD ["/bin/bash", "./cmd.sh"]
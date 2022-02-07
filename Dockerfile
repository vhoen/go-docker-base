# syntax=docker/dockerfile:1
FROM alpine:3.14.3

RUN echo "alias ll='ls -alF'" >> ~/.bashrc
RUN echo "alias la='ls A'" >> ~/.bashrc

RUN apk update
RUN apk add --no-cache git bash vim curl make musl-dev go

# RUN apk add --no-cache \
#         wkhtmltopdf \
#         xvfb \
#         ttf-dejavu ttf-droid ttf-freefont ttf-liberation

# RUN ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf;
# RUN chmod +x /usr/local/bin/wkhtmltopdf;

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
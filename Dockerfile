# syntax=docker/dockerfile:1
FROM centos:latest

RUN echo "alias ll='ls -alF'" >> ~/.bashrc
RUN echo "alias la='ls A'" >> ~/.bashrc

RUN yum -qy update && yum clean all
RUN yum -qy install git wget 

RUN wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
RUN tar -xzf go1.17.3.linux-amd64.tar.gz
RUN mv go /usr/local 
RUN rm go1.17.3.linux-amd64.tar.gz

USER root

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPRIVATE=*.pv-cp.net

ENV GOROOT=/usr/local/go 
ENV GOPATH=/go/src
ENV PATH=$GOROOT/bin:$GOPATH:$PATH 

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
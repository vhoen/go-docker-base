#!/bin/bash

godoc -http=:6060 -goroot=. &
go run main.go -config /go/src/go-onsite-app/parameters/parameters.json -debug=Debug
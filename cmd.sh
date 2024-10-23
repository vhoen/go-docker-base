#!/bin/sh
go build -o go-onsite-app -a . && dlv exec --accept-multiclient --log --headless --continue --listen :2345 --api-version 2 ./go-onsite-app
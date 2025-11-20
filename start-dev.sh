#!/bin/sh
set -e


#####<AIR>#####
# Air watches code and rebuilds binary, but skip running it
air -c .air.toml 
#####</AIR>#####

# #####<DELVE>#####
# go build -gcflags "all=-N -l" -o app
# # Start Delve headless, binds app port 8000 internally
# dlv exec ./app \
#     --headless \
#     --listen=:2345 \
#     --api-version=2 \
#     --accept-multiclient \
#     --log
#####</DELVE>#####
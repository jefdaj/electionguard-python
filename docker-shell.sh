#!/usr/bin/env bash

# Usage:
# 0. Install Docker.
# 1. Run this to spin up a dev container.
# 2. In the container, use `make` commands as described in the README
#    (except targets using docker compose; those run from the host system).

# Note that this bind mounts the current source code to /repo, hiding the
# version in the image. It also bind mounts that data dir for convenience
# retreiving generated files.

image_name=electionguard-python
./docker-build.sh $image_name

docker run -it \
  --mount type=bind,src=.,dst=/repo \
  --mount type=bind,src=./data,dst=/data \
  ${image_name}:latest bash

#!/usr/bin/env bash

# Usage:
# 0. Install Docker.
# 1. Run this to spin up a dev container.
# 2. In the container, use `make` commands as described in the README
#    (except targets using docker compose; those run outside).

image_name=electionguard-python-makefile-docker-env

docker build -t $image_name .

docker run -it \
  --mount type=bind,src=.,dst=/repo \
  --mount type=bind,src=./data,dst=/data \
  $image_name bash

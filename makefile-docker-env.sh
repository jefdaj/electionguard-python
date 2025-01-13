#!/usr/bin/env bash

# Usage:
# 0. install Docker
# 1. run this to spin up a dev container
# 2. in the container, use `make` commands as described in the README
#    (except targets using docker compose; those run outside)

image_name=electionguard-python-makefile-docker-env

docker build -t $image_name .

docker run -it \
  --mount type=bind,src=.,dst=/electionguard-python \
  --mount type=bind,src=./data,dst=/data \
  $image_name bash

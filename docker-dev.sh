#!/usr/bin/env bash

# Usage:
# 0. install Docker
# 1. run this to spin up a dev container
# 2. in the container, use `make` commands as described in the README

image_name=electionguard-python-env

docker build -t $image_name .

docker run -it \
  --mount type=bind,src=.,dst=/workspace \
  --mount type=bind,src=./.cache,dst=/root/.cache \
  $image_name bash

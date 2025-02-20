#!/usr/bin/env bash

# Increase this if you get an "OverflowError", "Killed", or similar.
MAX_MEMORY=1g

image_name=electionguard-python
./docker-build.sh $image_name
docker run --memory=$MAX_MEMORY -it ${image_name}:latest make test

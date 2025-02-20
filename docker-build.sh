#!/usr/bin/env bash

[[ -z "$1" ]] && image_name=electionguard-python || image_name="$1"
docker build -t $image_name .

FROM python:3.9-slim-bullseye AS base

RUN apt update && apt-get install -y \
    libgmp-dev libmpfr-dev libmpc-dev \
    graphviz jq \
    wget zip unzip make

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# upgraded to fix missing hashes bug
# https://stackoverflow.com/a/73388529
RUN pip install 'poetry==1.1.14'

# TODO is there a standard username?
# TODO can the uid/gid be pulled from current user's env?
RUN adduser --system --no-create-home --uid 1000 --gid 100 eg
USER eg

COPY ./ /repo
WORKDIR /repo

ENV PYTHONDONTWRITEBYTECODE=True

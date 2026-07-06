FROM python:3.9-slim-bullseye AS base

RUN apt update && apt-get install -y \
    libgmp-dev libmpfr-dev libmpc-dev \
    graphviz jq \
    wget zip unzip make

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install 'poetry==2.2.1'

COPY ./ /repo
WORKDIR /repo

ENV PYTHONDONTWRITEBYTECODE=True

# current debian, but old python + poetry to match electionguard release
FROM python:3.9-bookworm AS base
RUN apt update && apt-get install -y \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev
RUN pip install 'poetry==1.1.13'

# dev setup
# example usage:
# docker run -it --mount type=bind,src=.,dst=/workspace electionguard-python-env bash
WORKDIR /workspace

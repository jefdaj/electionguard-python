# current debian, but old python + poetry to match electionguard release
# see docker-dev.sh for expected usage
FROM python:3.9-bookworm AS base
RUN apt update && apt-get install -y \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev
RUN pip install 'poetry==1.1.13'
WORKDIR /workspace

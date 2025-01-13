FROM python:3.9-bullseye AS base
RUN apt update && apt-get install -y \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    graphviz
RUN pip install 'poetry==1.1.13'
ENV POETRY_REQUESTS_MAX_RETRIES=25
WORKDIR /electionguard-python

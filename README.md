![ElectionGuard Python](images/electionguard-banner.svg)
======================

This is my fork for use in [the Cardano integration](https://github.com/jefdaj/electionguard-cardano).

Main changes so far:

- [Fixed a `poetry.lock` bug](https://github.com/jefdaj/electionguard-python/commit/2d2f9e0901b70ae2adea09b749dd03757395b977)
- Added a [Dockerfile](./Dockerfile) along with [build](./docker-build.sh), [test](./docker-test.sh), and [hack](./docker-shell.sh) scripts
- Published [the Docker image](https://ghcr.io/jefdaj/electionguard-python)

## Build

```bash
./docker-build.sh
```

![docker-build demo](./images/docker-build.gif)

## Test

```bash
./docker-test.sh
```

![docker-test demo](./images/docker-test.gif)

## Hack

Substitute your system package manager for Nix here if you want.

The Docker shell bind mounts the source code + data dirs,
so you can edit from the host system and work with sample files easily.

Run the docker compose make commands in a host nix-shell.

```bash
nix-shell -p docker-compose gnumake python3
make start-db
```

Run the other make commands in the electionguard-python container.

```bash
nix-shell -p docker-compose
./docker-shell.sh
make eg-e2e-simple-election
```

![docker-shell demo](./images/docker-shell.gif)

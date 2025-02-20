# ElectionGuard Python

This is my fork for use in [the Cardano integration](https://github.com/jefdaj/electionguard-cardano).

Main changes so far:

- Fixed a `poetry.lock` bug
- Cleaner Docker/Nix dev setup

## Build and test

```bash
./docker-build.sh
./docker-test.sh
```

## Hack

Substitute your system package manager for Nix here if you want.

```bash
# run the docker compose make commands in a host nix-shell
# for example:
nix-shell -p docker-compose gnumake python3
make start-db
```

```bash
# run the other make commands in the electionguard-python container
# for example:
nix-shell -p docker-compose
./docker-shell.sh
make test
make eg-e2e-simple-election
```

The Docker shell bind mounts the source code + data dirs,
so you can edit from the host system and work with sample files easily.

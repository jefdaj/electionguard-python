![ElectionGuard Python](images/electionguard-banner.svg)
======================

This is my fork for use in [the Cardano integration](https://github.com/jefdaj/electionguard-cardano).

Main changes:

- ~~[Fixed a `poetry.lock` bug](https://github.com/jefdaj/electionguard-python/commit/2d2f9e0901b70ae2adea09b749dd03757395b977)~~ Fixed upstream now
- Added a [Dockerfile](./Dockerfile) along with [build](./docker-build.sh), [test](./docker-test.sh), and [hack](./docker-shell.sh) scripts
- Published [the Docker image](https://ghcr.io/jefdaj/electionguard-python)
- Packaged with Nix, including [new Docker image](https://ghcr.io/jefdaj/electionguard-python) with upstream changes as of 2026-07-06

# New Nix Build

```bash
# build Python lib + binaries
nix build
```

```bash
# dev env that works with Makefile
nix develop
make all
```

```bash
# build binary and run eg e2e tests with it
nix flake check
```

```
# build and test docker image as in Makefile
nix build .#packages.dockerImage
docker load < result

docker run -v ./data:/data electionguard:1.4.0-py313.nix setup --guardian-count=2 --quorum=2 --manifest=/data/election_manifest_simple.json  --package-dir=/data/out/public_encryption_package --keys-dir=/data/out/test_data_private_guardian_data

docker run -v ./data:/data electionguard:1.4.0-py313.nix e2e --guardian-count=2 --quorum=2 --manifest=/data/election_manifest_simple.json --ballots=/data/plaintext_ballots_simple.json --spoil-id=25a7111b-4334-425a-87c1-f7a49f42b3a2 --output-record="/data/out/election_record.zip"
```

# Old Docker Build

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

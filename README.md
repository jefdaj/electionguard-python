![ElectionGuard Python](images/electionguard-banner.svg)
======================

This is my fork for use in [the Cardano integration](https://github.com/jefdaj/electionguard-cardano).

Main changes:

- ~~[Fixed a `poetry.lock` bug](https://github.com/jefdaj/electionguard-python/commit/2d2f9e0901b70ae2adea09b749dd03757395b977)~~ obsolete
- ~~Added a [Dockerfile](./Dockerfile) along with [build](./docker-build.sh), [test](./docker-test.sh), and [hack](./docker-shell.sh) scripts~~ obsolete
- ~~Published [the Docker image](https://ghcr.io/jefdaj/electionguard-python)~~ obsolete
- Packaged with Nix, including [new Docker image](https://ghcr.io/jefdaj/electionguard-python) with upstream changes as of 2026-07-06

Build Python lib + binaries:

```bash
nix build
```

Dev env that works with Makefile:

```bash
nix develop
make all
```

Build binary and run eg e2e tests with it:

```bash
nix flake check
```

Build and test Docker image as in Makefile.
Outputs appear in `./data/out`:

```
nix build .#packages.dockerImage
docker load < result

docker run -v ./data:/data electionguard:1.4.0-py313.nix eg setup \
  --guardian-count=2 --quorum=2 \
  --manifest=/data/election_manifest_simple.json  \
  --package-dir=/data/out/public_encryption_package \
  --keys-dir=/data/out/test_data_private_guardian_data

docker run -v ./data:/data electionguard:1.4.0-py313.nix eg e2e \
  --guardian-count=2 --quorum=2 \
  --manifest=/data/election_manifest_simple.json \
  --ballots=/data/plaintext_ballots_simple.json \
  --spoil-id=25a7111b-4334-425a-87c1-f7a49f42b3a2 \
  --output-record="/data/out/election_record.zip"
```

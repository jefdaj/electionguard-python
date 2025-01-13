# ElectionGuard Python

This is my fork for use in [the Cardano integration](https://github.com/jefdaj/electionguard-cardano).

Main changes so far:

- Fixed a `poetry.lock` bug
- Nix development setup

## Nix development setup

```bash
# run the docker-related make commands in a host nix-shell
# for example:
nix-shell -p docker-compose gnumake python3
make start-db
```

```bash
# run the rest in the electionguard-python-makefile-env container
# for example:
nix-shell -p docker-compose
./makefile-docker-env.sh
make test
make eg-e2e-simple-election
```

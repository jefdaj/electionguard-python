{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # last commit to pyproject.toml was Aug 2022, so this seems like a good starting point:
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        electionguard = { poetry2nix, lib }: poetry2nix.mkPoetryApplication {
          projectDir = self;

          # overrides = poetry2nix.overrides.withDefaults (final: super:
          #   lib.mapAttrs
          #     (attr: systems: super.${attr}.overridePythonAttrs
          #       (old: {
          #         nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ map (a: final.${a}) systems;
          #       }))
          #     {
          #       # https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
          #       "bottle" = [ "setuptools" ];
          #       "bottle-websocket" = [ "setuptools" ];
          #       "eel" = [ "setuptools" ];
          #       "gmpy2" = [ gmp ];
          #     }
          # );

          overrides = poetry2nix.defaultPoetryOverrides.extend (final: super: {

            # "bottle-websocket" = super."bottle-websocket".overridePythonAttrs (old: {
            #   buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            # });

            # "gmpy" = super."gmpy".overridePythonAttrs (old: {
            #   nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ gmp4 ];
            # });

          });

        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            poetry2nix.overlays.default
            (final: _: {
              electionguard = final.callPackage electionguard { };
            })
          ];
        };
      in
      {
        packages.default = pkgs.electionguard;
        devShells = {
          # Shell for app dependencies.
          #
          #     nix develop
          #
          # Use this shell for developing your app.
          default = pkgs.mkShell {
            inputsFrom = [ pkgs.electionguard ];
          };

          # Shell for poetry.
          #
          #     nix develop .#poetry
          #
          # Use this shell for changes to pyproject.toml and poetry.lock.
          poetry = pkgs.mkShell {
            packages = [ pkgs.poetry ];
          };
        };
        legacyPackages = pkgs;
      }
    );
}

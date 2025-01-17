{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # TODO which nixpkgs to use?
    # release-22.05? nope, too old for poetry2nix
    # release-22.11? nope
    # release-23.11? nope
    # release-24.11? maybe...
    # release-24.05? 
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";

    poetry2nix = {
      url = "github:nix-community/poetry2nix";

      # TODO does commenting this out help?
      inputs.nixpkgs.follows = "nixpkgs";

      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        electionguard = { poetry2nix, lib, gmp }: poetry2nix.mkPoetryApplication {

          # TODO does this help?
          python = pkgs.python39;

          projectDir = self;

          # overrides = poetry2nix.overrides.withDefaults (final: super:
          #   lib.mapAttrs
          #     (attr: systems: super.${attr}.overridePythonAttrs
          #       (old: {
          #         nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ map (a: final.${a}) systems;
          #       }))
          #     {
          #       # https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename

          #       # TODO do these help?
          #       # "bottle" = [ "setuptools" ];
          #       # "bottle-websocket" = [ "setuptools" ];
          #       # "eel" = [ "setuptools" ];
          #       # "gmpy2" = [ gmp ];

          #     }
          # );

          # TODO do these help?
          overrides = poetry2nix.defaultPoetryOverrides.extend (final: super: {

            # "bottle" = super."bottle".overridePythonAttrs (old: {
            #   buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            # });

            # "bottle-websocket" = super."bottle-websocket".overridePythonAttrs (old: {
            #   buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            # });

            "gmpy2" = super."gmpy2".overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.gmp.dev pkgs.mpfr.dev pkgs.libmpc ];
            });

            "hatchling" = super."hatchling".overridePythonAttrs (old: {
              # TODO work on this
              # buildInputs = (old.buildInputs or [ ]) ++ [ super.pathspec ];
              # nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.pathspec ];
            });

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

{
  description = "ElectionGuard (uv2nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, uv2nix, pyproject-nix, pyproject-build-systems, ... }:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux"; # TODO add others? may depond on whether mac/win users run linux Docker images
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python313;

      # Static sample data
      # TODO vendor this into the repo? it's been the same for years now
      # TODO is it actually needed for any tests?
      # egSampleData = pkgs.fetchurl {
      #   url = "https://github.com/microsoft/electionguard/releases/download/v1.0/sample-data.zip";
      #   sha256sum = "144nl31sriynbhy4cf0ia5izs13zc8l69qfr966nbm69rdj0wyyk";
      # };

      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";         # or "sdist" if you need source builds
      };

      pyprojectOverrides = final: prev:
        let
          addBuildSystem = names: pkg: pkg.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [])
              ++ final.resolveBuildSystem names;
          });
        in {
          atomicwrites     = addBuildSystem { setuptools = []; wheel = []; } prev.atomicwrites;
          bottle-websocket = addBuildSystem { setuptools = []; wheel = []; } prev.bottle-websocket;
          eel              = addBuildSystem { setuptools = []; wheel = []; } prev.eel;
          electionguard    = addBuildSystem { hatchling = []; editables = []; } prev.electionguard;
          gmpy2 = (addBuildSystem { setuptools = []; cython = []; } prev.gmpy2).overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ ];
            buildInputs = (old.buildInputs or []) ++ [ pkgs.gmp pkgs.mpfr pkgs.libmpc ];
            NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
            NIX_LDFLAGS = "-L${pkgs.gmp}/lib";
          });
        };

        pythonSet =
          (pkgs.callPackage pyproject-nix.build.packages { inherit python; })
            .overrideScope (lib.composeManyExtensions [
              pyproject-build-systems.overlays.default
              overlay
              pyprojectOverrides
            ]);
    in
    rec {
      packages.${system}.default =
        pythonSet.mkVirtualEnv "electionguard-env" workspace.deps.default;

      # dev shell with editable install
      devShells.${system}.default =
        let
          editableOverlay = workspace.mkEditablePyprojectOverlay {
            root = "$REPO_ROOT";
          };
          editablePythonSet = pythonSet.overrideScope editableOverlay;
          venv = editablePythonSet.mkVirtualEnv "electionguard-dev-env"
            workspace.deps.all;
        in
        pkgs.mkShell {
          packages = with pkgs; [
            graphviz
            jq
            unzip
            uv
            zip

            venv
          ];
          env = {
            UV_NO_SYNC = "1";
            UV_PYTHON = "${venv}/bin/python";
            UV_PYTHON_DOWNLOADS = "never";
          };
          shellHook = ''
            unset PYTHONPATH
            export REPO_ROOT=$(git rev-parse --show-toplevel)
          '';
        };

      checks.${system} = {

        # This one is dynamic, and I didn't bother yet checking that the zip includes particular filename patterns.
        e2e-simple-election = pkgs.runCommand "electionguard-e2e-simple-election-check"
          { nativeBuildInputs = [ packages.${system}.default ]; }
          ''
            mkdir -p $out
            eg e2e \
              --guardian-count=2 --quorum=2 \
              --manifest=${./data/election_manifest_simple.json} \
              --ballots=${./data/plaintext_ballots_simple.json} \
              --spoil-id=25a7111b-4334-425a-87c1-f7a49f42b3a2 \
              --output-record=$out/election_record.zip
          '';

        e2e-setup =
          let expectedTree = nixpkgs.lib.concatStringsSep "\n" [
            "public_encryption_package"
            "public_encryption_package/constants.json"
            "public_encryption_package/context.json"
            "public_encryption_package/guardians"
            "public_encryption_package/guardians/guardian_1.json"
            "public_encryption_package/guardians/guardian_2.json"
            "public_encryption_package/manifest.json"
            "test_data_private_guardian_data"
            "test_data_private_guardian_data/guardian_1.json"
            "test_data_private_guardian_data/guardian_2.json"
          ];
          in pkgs.runCommand "electionguard-e2e-setup-check"
          {
              nativeBuildInputs = [ packages.${system}.default ];
              expectedTree = expectedTree;
          }
          ''
            mkdir -p $out
            cd $out
            eg setup \
              --guardian-count=2 --quorum=2 \
              --manifest=${./data/election_manifest_simple.json} \
              --package-dir=public_encryption_package \
              --keys-dir=test_data_private_guardian_data

            actual=$(find . -mindepth 1 | sed 's|^\./||' | sort)

            if [ "$actual" != "$expectedTree" ]; then
              echo "Tree mismatch:" >&2
              diff <(echo "$expected") <(echo "$actual") >&2 || true
              exit 1
            fi
          '';
      };

    };
}

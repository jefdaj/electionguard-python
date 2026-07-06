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
      system = "x86_64-linux";              # add others via flake-utils if needed
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python313;

      # Load workspace from your uv.lock
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      # Base overlay generated from the lock file
      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";         # or "sdist" if you need source builds
      };

      # ---- YOUR NATIVE-DEP OVERRIDES ----
      pyprojectOverrides = final: prev: {

	gmpy2 = prev.gmpy2.overrideAttrs (old: {
	  nativeBuildInputs = (old.nativeBuildInputs or [ ])
	    ++ final.resolveBuildSystem { setuptools = []; cython = []; };
	  buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.gmp pkgs.mpfr pkgs.libmpc ];
	  NIX_CFLAGS_COMPILE = "-I${pkgs.gmp.dev}/include";
	  NIX_LDFLAGS = "-L${pkgs.gmp}/lib";
	});

        # these all fail to build without an override because they expect ambient setuptools:
	atomicwrites = prev.atomicwrites.overrideAttrs (old: {
	  nativeBuildInputs = (old.nativeBuildInputs or [ ])
	    ++ final.resolveBuildSystem {
	      setuptools = [ ];
	      wheel = [ ];
	    };
	});
        bottle-websocket = prev.bottle-websocket.overrideAttrs (old: {
	  nativeBuildInputs = (old.nativeBuildInputs or [ ])
	    ++ final.resolveBuildSystem {
	      setuptools = [ ];
	      wheel = [ ];
	    };
	});
        eel = prev.eel.overrideAttrs (old: {
	  nativeBuildInputs = (old.nativeBuildInputs or [ ])
	    ++ final.resolveBuildSystem {
	      setuptools = [ ];
	      wheel = [ ];
	    };
	});

	electionguard = prev.electionguard.overrideAttrs (old: {
	  nativeBuildInputs = (old.nativeBuildInputs or [ ])
	    ++ final.resolveBuildSystem {
	      hatchling = [ ];
	      editables = [ ];
	    };
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
    {
      packages.${system}.default =
        pythonSet.mkVirtualEnv "electionguard-env" workspace.deps.default;

      packages.electionguard = pythonSet.electionguard;

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
          packages = [ venv pkgs.uv ];
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
    };
}

{
  description = "Nix Flake Template for Python using uv2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:adisbladis/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    pyproject-nix,
    uv2nix,
    systems,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});

    workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

    overlay = workspace.mkPyprojectOverlay {
      sourcePreference = "wheel"; # or sourcePreference = "sdist";
    };

    pyprojectOverrides = _final: _prev: {
    };

    pythonSets = forEachSystem(system:
      (pkgsFor.${system}.callPackage pyproject-nix.build.packages {
        python = pkgsFor.${system}.python312;
      }).overrideScope
        (nixpkgs.lib.composeExtensions overlay pyprojectOverrides)
      );
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = let
        editableOverlay = workspace.mkEditablePyprojectOverlay {
          root = "$REPO_ROOT";
        };
        editablePythonSets = pythonSets.${system}.overrideScope editableOverlay;

        virtualenv = editablePythonSets.mkVirtualEnv "app" workspace.deps.all;
      in pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          uv
          virtualenv
        ];
        shellHook = ''
          unset PYTHONPATH
          export REPO_ROOT=$(git rev-parse --show-toplevel)
        '';
      };
    });

    packages = forEachSystem (system: {
      default = pythonSets.${system}.mkVirtualEnv "app" workspace.deps.default;
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/app";
      };
    });
  };
}

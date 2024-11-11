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
    ...
  }: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgs = forEachSystem (system: import nixpkgs {inherit system;});
    lib = forEachSystem (system: pkgs.${system}.lib);

    workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

    overlay = workspace.mkPyprojectOverlay {
      sourcePreference = "wheel"; # or sourcePreference = "sdist";
    };

    pyprojectOverrides = _final: _prev: {
    };

    pythonSet = forEachSystem(system:
      (pkgs.${system}.callPackage pyproject-nix.build.packages {
        python = pkgs.${system}.python312;
      }).overrideScope
        (lib.${system}.composeExtensions overlay pyprojectOverrides)
      );
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = let
        editableOverlay = workspace.mkEditablePyprojectOverlay {
          root = "$REPO_ROOT";
        };
        editablePythonSet = pythonSet.${system}.overrideScope editableOverlay;

        virtualenv = editablePythonSet.mkVirtualEnv "app" workspace.deps.all;
      in pkgs.${system}.mkShell {
        packages = with pkgs.${system}; [
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
      default = pythonSet.${system}.mkVirtualEnv "app" workspace.deps.default;
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/app";
      };
    });
  };
}

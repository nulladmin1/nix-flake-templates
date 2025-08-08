{
  description = "project_name";

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
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    pyproject-nix,
    uv2nix,
    pyproject-build-systems,
    ...
  }: let
    inherit (nixpkgs) lib;

    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        python = forEachSystem (system: pkgs.python312);

        workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ./.;};

        overlay = workspace.mkPyprojectOverlay {
          sourcePreference = "wheel"; # or sourcePreference = "sdist";
        };

        pyprojectOverrides = _final: _prev: {
        };
      in
        f {
          inherit pkgs python workspace;

          pythonSets =
            (pkgs.callPackage pyproject-nix.build.packages {
              inherit python;
            })
            .overrideScope
            (lib.composeManyExtensions
              [
                pyproject-build-systems.overlays.default
                overlay
                pyprojectOverrides
              ]);
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      workspace,
      pythonSets,
      ...
    }: {
      default = let
        editableOverlay = workspace.mkEditablePyprojectOverlay {
          root = "$REPO_ROOT";
        };
        editablePythonSets = pythonSets.overrideScope (
          lib.composeManyExtensions [
            editableOverlay

            (final: prev: {
              project_name = prev.project_name.overrideAttrs (old: {
                src = lib.fileset.toSource {
                  root = old.src;
                  fileset = lib.fileset.unions (map (file: old.src + file) [
                    "/pyproject.toml"
                    "/README.md"
                    "/project_name"
                  ]);
                };
                nativeBuildInputs =
                  old.nativeBuildInputs
                  ++ final.resolveBuildSystem {
                    editables = [];
                  };
              });
            })
          ]
        );

        virtualenv = editablePythonSets.mkVirtualEnv "project_name" workspace.deps.all;
      in
        pkgs.mkShell {
          packages = with pkgs; [
            uv
            virtualenv
          ];

          env = {
            UV_NO_SYNC = "1";
            UV_PYTHON = "${virtualenv}/bin/python";
            UV_PYTHON_DOWNLOADS = "never";
          };

          shellHook = ''
            unset PYTHONPATH
            export REPO_ROOT=$(git rev-parse --show-toplevel)
          '';
        };
    });

    packages = forEachSystem ({
      pkgs,
      python,
      workspace,
      ...
    }: {
      default = python.mkVirtualEnv "project_name" workspace.deps.default;
    });

    apps = forEachSystem ({pkgs, ...}: {
      default = {
        type = "app";
        program = "${self.packages.${pkgs.system}.default}/bin/project_name";
      };
    });
  };
}

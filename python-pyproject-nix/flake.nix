{
  description = "Nix Flake Template for Python with pyproject-nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    pyproject-nix,
    systems,
    ...
  }: let
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        f {
          inherit pkgs;
          python = forEachSystem (system: pkgs.python312);
        });
    project = pyproject-nix.lib.project.loadPyproject {projectRoot = ./.;};
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      python,
      ...
    }: {
      default = let
        arg = project.renderers.withPackages {inherit python;};

        pythonEnv = python.withPackages arg;
      in
        pkgs.mkShell {
          packages = [
            pythonEnv
          ];
        };
    });

    packages = forEachSystem ({
      pkgs,
      python,
      ...
    }: {
      default = let
        attrs = project.renderers.buildPythonPackage {inherit python;};
      in
        python.pkgs.buildPythonPackage attrs;
    });

    apps = forEachSystem ({pkgs, ...}: {
      default = {
        type = "app";
        program = "${self.packages.${pkgs.system}.default}/bin/project_name";
      };
    });
  };
}

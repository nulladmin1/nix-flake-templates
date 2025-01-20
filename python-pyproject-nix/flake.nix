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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});
    project = pyproject-nix.lib.project.loadPyproject {projectRoot = ./.;};

    python = forEachSystem (system: pkgsFor.${system}.python312);
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = let
        arg = project.renderers.withPackages {python = python.${system};};

        pythonEnv = python.${system}.withPackages arg;
      in
        pkgsFor.${system}.mkShell {
          packages = [
            pythonEnv
          ];
        };
    });

    packages = forEachSystem (system: {
      default = let
        attrs = project.renderers.buildPythonPackage {python = python.${system};};
      in
        python.${system}.pkgs.buildPythonPackage attrs;
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/project_name";
      };
    });
  };
}

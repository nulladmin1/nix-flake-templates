{
  description = "project_name";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  }: let
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({pkgs, ...}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            python311
          ]
          ++ (with python311Packages; [
            setuptools
            pip
          ]);
      };
    });

    packages = forEachSystem ({pkgs, ...}: {
      default = pkgs.python311Packages.buildPythonPackage {
        pname = "project_name";
        version = "0.1.0";
        src = ./.;
        format = "pyproject";

        nativeBuildInputs = with pkgs.python311Packages; [
          setuptools
        ];
      };
    });

    apps = forEachSystem ({pkgs, ...}: {
      default = {
        type = "app";
        program = "${self.packages.${pkgs.system}.default}/bin/project_name";
      };
    });
  };
}

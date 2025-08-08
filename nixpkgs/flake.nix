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
    formatter = forEachSystem ({pkgs, ...}: pkgs.nixfmt-rfc-style);

    devShells = forEachSystem ({pkgs, ...}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt-rfc-style
        ];
      };
    });

    packages = forEachSystem ({pkgs, ...}: {
      default = pkgs.callPackage ./package.nix;
    });

    apps = forEachSystem ({pkgs, ...}: {
      default = {
        type = "app";
        program = pkgs.lib.getExe self.packages.${pkgs.system}.default;
      };
    });
  };
}

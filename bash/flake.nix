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
    inherit (nixpkgs) lib;
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    formatter = forEachSystem ({pkgs}: pkgs.alejandra);

    devShells = forEachSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          shellcheck
          shfmt
        ];
      };
    });

    packages = forEachSystem ({pkgs}: {
      default = pkgs.writeShellScriptBin "project_name" (builtins.readFile ./hello.sh);
    });

    apps = forEachSystem ({pkgs}: {
      default = {
        type = "app";
        program = "${lib.getExe self.packages.${pkgs.system}.default}";
      };
    });
  };
}

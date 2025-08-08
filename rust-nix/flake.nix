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
        packages = with pkgs; [
          rustc
          cargo
        ];
      };
    });

    packages = forEachSystem ({pkgs, ...}: {
      default = pkgs.rustPlatform.buildRustPackage {
        pname = "project_name";
        version = "0.1.0";
        src = ./.;
        cargoHash = "sha256-MtgvLheMrKnQCZPsI80eFsQFMHC/Xiqi2Tjc4CtmQnU=";
        # cargoHash = pkgsFor.${system}.lib.fakeHash;
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

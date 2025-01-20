{
  description = "project_name";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    gomod2nix,
    systems,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system:
      import nixpkgs {
        inherit system;
        overlays = [
          gomod2nix.overlays.default
        ];
      });
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: let
      goEnv = pkgsFor.${system}.mkGoEnv {pwd = ./.;};
    in {
      default = pkgsFor.${system}.mkShell {
        packages = [
          goEnv
          gomod2nix.packages.${system}.default
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgsFor.${system}.buildGoApplication {
        pname = "project_name";
        version = "0.1.0";
        pwd = ./.;
        src = ./.;
        modules = ./gomod2nix.toml;
      };
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/src";
      };
    });
  };
}

{
  description = "Nix Flake Template for Go using GoMod2Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    gomod2nix,
  }: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgs = forEachSystem (system:
      import nixpkgs {
        inherit system;
        overlays = [
          gomod2nix.overlays.default
        ];
      });
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: let
      goEnv = pkgs.${system}.mkGoEnv {pwd = ./.;};
    in {
      default = pkgs.${system}.mkShell {
        packages = [
          goEnv
          gomod2nix.packages.${system}.default
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgs.${system}.buildGoApplication {
        pname = "hello";
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

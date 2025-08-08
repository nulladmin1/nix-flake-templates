{
  description = "project_name";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    crane.url = "github:ipetkov/crane";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
    crane,
    systems,
    ...
  }: let
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system: let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [
            fenix.overlays.default
          ];
        };

        rust-toolchain = pkgs.fenix.stable.withComponents [
          "cargo"
          "llvm-tools"
          "rustc"
        ];
      in
        f {
          inherit pkgs rust-toolchain;

          rust-toolchain-devtools = pkgs.fenix.stable.withComponents [
            "rust-analyzer"
            "rustfmt"
            "clippy"
          ];

          craneLib = (crane.mkLib pkgs).overrideToolchain rust-toolchain;
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      craneLib,
      rust-toolchain-devtools,
      ...
    }: {
      default = craneLib.devShell {
        buildInputs = [rust-toolchain-devtools];
      };
    });

    packages = forEachSystem ({
      pkgs,
      craneLib,
      ...
    }: let
      src = craneLib.cleanCargoSource ./.;
      cargoArtifact = craneLib.buildDepsOnly {
        inherit src;
      };
    in {
      default = craneLib.buildPackage {
        inherit cargoArtifact;
        inherit src;
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

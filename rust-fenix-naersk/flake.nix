{
  description = "project_name";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    naersk.url = "github:nix-community/naersk";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    naersk,
    fenix,
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
      in
        f {
          inherit pkgs;

          rust-toolchain = pkgs.fenix.stable.withComponents [
            "cargo"
            "llvm-tools"
            "rustc"
          ];

          rust-toolchain-devtools = pkgs.fenix.stable.withComponents [
            "rust-analyzer"
            "rustfmt"
            "clippy"
          ];
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      rust-toolchain,
      rust-toolchain-devtools,
      ...
    }: {
      default = pkgs.mkShell {
        packages = [
          rust-toolchain
          rust-toolchain-devtools
        ];
        RUST_SRC_PATH = "${rust-toolchain.rust-src}/lib/rustlib/src/rust/library";
      };
    });

    packages = forEachSystem ({
      pkgs,
      rust-toolchain,
      ...
    }: {
      default =
        (pkgs.callPackage naersk {
          inherit (rust-toolchain) cargo rustc;
        })
        .buildPackage {
          src = ./.;
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

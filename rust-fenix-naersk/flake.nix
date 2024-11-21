{
  description = "Nix Flake Template for Rust using Fenix and Naersk";

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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system:
      import nixpkgs {
        inherit system;
        overlays = [
          fenix.overlays.default
        ];
      });
    rust-toolchain = forEachSystem (system: pkgsFor.${system}.fenix.complete);
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with rust-toolchain.${system}; [
          cargo
          rustc
          clippy
          rustfmt
        ];
        RUST_SRC_PATH = "${rust-toolchain.${system}.rust-src}/lib/rustlib/src/rust/library";
      };
    });

    packages = forEachSystem (system: {
      default = (pkgsFor.${system}.callPackage naersk {
        cargo = rust-toolchain.${system}.cargo;
        rustc = rust-toolchain.${system}.rustc;
      }).buildPackage {
        src = ./.;
      };
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/rust";
      };
    });
  };
}

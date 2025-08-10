{
  description = "iced-tutorial";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    fenix,
    ...
  }: let
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system:
        f rec {
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
            "rust-src"
          ];

          rust-toolchain-devtools = pkgs.fenix.stable.withComponents [
            "rust-analyzer"
            "rustfmt"
            "clippy"
          ];

          deps = with pkgs; [
            libxkbcommon
            pkg-config
            wayland
          ];
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      rust-toolchain,
      rust-toolchain-devtools,
      deps,
      ...
    }: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            rust-toolchain
            rust-toolchain-devtools

            libcosmicAppHook
          ]
          ++ deps;
      };
    });

    packages = forEachSystem ({
      pkgs,
      rust-toolchain,
      deps,
      ...
    }: {
      default = let
        rustPlatform = pkgs.makeRustPlatform {
          cargo = rust-toolchain;
          rustc = rust-toolchain;
        };
      in
        rustPlatform.buildRustPackage {
          pname = "iced-tutorial";
          version = "0.1.0";
          src = ./.;
          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          buildInputs = deps;

          nativeBuildInputs = with pkgs; [
            libcosmicAppHook
            git # for vergen
          ];
        };
    });

    apps = forEachSystem ({pkgs, ...}: {
      default = {
        type = "app";
        program = "${self.packages.${pkgs.system}.default}/bin/iced-tutorial";
      };
    });
  };
}

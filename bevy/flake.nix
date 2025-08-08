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
    crane,
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

        rust-toolchain = pkgs.fenix.stable.withComponents [
          "cargo"
          "llvm-tools"
          "rustc"
        ];

        bevy-runtime-deps = with pkgs; [
          pkg-config
          alsa-lib
          vulkan-tools
          vulkan-headers
          vulkan-loader
          vulkan-validation-layers
          libudev-zero
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          xorg.libxcb
          libxkbcommon
          wayland
        ];

        bevy-build-deps = with pkgs; [
          clang
          lld
        ];
      in
        f {
          inherit pkgs;
          craneLib = (crane.mkLib pkgs).overrideToolchain rust-toolchain;

          all-deps = bevy-build-deps ++ bevy-runtime-deps;
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      craneLib,
      all-deps,
      ...
    }: {
      default = craneLib.devShell {
        packages = all-deps;
        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath (with pkgs; [
            libxkbcommon
            vulkan-loader
          ])}"
        '';
      };
    });
    packages = forEachSystem ({
      craneLib,
      all-deps,
      ...
    }: {
      default = craneLib.buildPackage {
        src = craneLib.cleanCargoSource ./.;
        nativeBuildInputs = all-deps;
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

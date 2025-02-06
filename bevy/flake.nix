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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system:
      import nixpkgs {
        inherit system;
        overlays = [
          fenix.overlays.default
        ];
      });
    rust-toolchain = forEachSystem (system: pkgsFor.${system}.fenix.stable);

    bevy-runtime-deps = forEachSystem (system:
      with pkgsFor.${system}; [
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
      ]);
    bevy-build-deps = forEachSystem (system:
      with pkgsFor.${system}; [
        clang
        lld
      ]);
    all-deps = forEachSystem (system: bevy-build-deps.${system} ++ bevy-runtime-deps.${system});
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with rust-toolchain.${system};
          [
            cargo
            rustc
            clippy
            rustfmt
          ]
          ++ all-deps.${system};
        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgsFor.${system}.lib.makeLibraryPath (with pkgsFor.${system}; [
            libxkbcommon
            vulkan-loader
          ])}"
        '';
        RUST_SRC_PATH = "${rust-toolchain.${system}.rust-src}/lib/rustlib/src/rust/library";
      };
    });
    # TODO Figure out packages and apps
  };
}

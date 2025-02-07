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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system:
      import nixpkgs {
        inherit system;
        overlays = [
          fenix.overlays.default
        ];
      });
    rust-toolchain = forEachSystem (system:
      pkgsFor.${system}.fenix.stable.withComponents [
        "cargo"
        "llvm-tools"
        "rustc"
      ]);
    craneLib = forEachSystem (system: (crane.mkLib pkgsFor.${system}).overrideToolchain rust-toolchain.${system});
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = craneLib.${system}.devShell {};
    });

    packages = forEachSystem (system: let
      src = craneLib.${system}.cleanCargoSource ./.;
      cargoArtifact = craneLib.${system}.buildDepsOnly {
        inherit src;
      };
    in {
      default = craneLib.${system}.buildPackage {
        inherit cargoArtifact;
        inherit src;
      };
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/project_name";
      };
    });
  };
}

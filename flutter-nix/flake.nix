{
  description = "Nix Flake Template for Flutter with Nix Builders";

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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor =
      forEachSystem (system: import nixpkgs {inherit system;});
    flutterPackage = forEachSystem (system: pkgsFor.${system}.flutter327);
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = [
          flutterPackage
        ];
      };
    });

    packages = forEachSystem (system: {
      default = flutterPackage.${system}.buildFlutterApplication {
        pname = "app";
        version = "0.1.0";
        src = ./.;
        dartSdk = pkgsFor.${system}.dart;
        autoDepsList = true;
        autoPubspecLock = ./pubspec.lock;
        targetFlutterPlatform = "web";
      };
      web = self.packages.${system}.default.overrideAttrs (old: {
        targetFlutterPlatform = "web";
      });
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/app";
      };
    });
  };
}

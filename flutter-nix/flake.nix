{
  description = "project_name";

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
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        f {
          inherit pkgs;

          flutterPackage = pkgs.flutter327;
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      flutterPackage,
      ...
    }: {
      default = pkgs.mkShell {
        packages = [
          flutterPackage
        ];
      };
    });

    packages = forEachSystem ({
      pkgs,
      flutterPackage,
      ...
    }: {
      default = flutterPackage.buildFlutterApplication {
        pname = "project_name";
        version = "0.1.0";
        src = ./.;
        dartSdk = pkgs.dart;
        autoDepsList = true;
        autoPubspecLock = ./pubspec.lock;
      };
      web = self.packages.default.overrideAttrs (old: {
        targetFlutterPlatform = "web";
      });
    });

    apps = forEachSystem ({pkgs, ...}: {
      default = {
        type = "app";
        program = "${self.packages.${pkgs.system}.default}/bin/project_name";
      };
    });
  };
}

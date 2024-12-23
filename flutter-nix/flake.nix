{
  description = "Nix Flake Template for Flutter";

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
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          androidenv.androidPkgs.androidsdk
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgsFor.${system}.flutter327.buildFlutterApplication {
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

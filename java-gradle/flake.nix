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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});

    gradle_pkg = forEachSystem (system: pkgsFor.${system}.gradle);
    java_pkg = forEachSystem (system: pkgsFor.${system}.jdk);
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages =
          [
            gradle_pkg.${system}
            java_pkg.${system}
          ]
          ++ (with pkgsFor.${system}; [
            # Other packages...
          ]);
      };
    });

    packages = forEachSystem (system: {
      default =
        pkgsFor.${system}.stdenv.mkDerivation (self: {
          
        });
    });

    apps = forEachSystem (system: {
      default = {\
        type = "app";
        program = "${self.packages.${system}.default}/bin/hello";
      };
    });
  };
}

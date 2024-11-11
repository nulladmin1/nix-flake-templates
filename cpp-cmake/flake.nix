{
  description = "Nix Flake Template for C++";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          libllvm
          cmake
          gtest
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgsFor.${system}.stdenv.mkDerivation {
        pname = "cpp";
        version = "0.1.0";
        src = ./.;

        nativeBuildInputs = with pkgsFor.${system}; [
          cmake
        ];
        buildInputs = with pkgsFor.${system}; [
          gtest
        ];
      };
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/hello";
      };
    });
  };
}

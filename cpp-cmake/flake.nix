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
    pkgs = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgs.${system}.mkShell {
        packages = with pkgs.${system}; [
          libllvm
          cmake
          gtest
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgs.${system}.stdenv.mkDerivation {
        pname = "cpp";
        version = "0.1.0";
        src = ./.;

        nativeBuildInputs = with pkgs.${system}; [
          cmake
        ];
        buildInputs = with pkgs.${system}; [
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

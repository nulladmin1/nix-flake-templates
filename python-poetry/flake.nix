{
  description = "Nix Flake Template for Python using Poetry";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs = {
    self,
    nixpkgs,
    poetry2nix,
  }: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgs = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    devShells = forEachSystem (system: {
      default = pkgs.${system}.mkShell {
        packages = with pkgs.${system}; [
          python3
          poetry
        ];
      };
    });

    apps = forEachSystem (system: let
      inherit (poetry2nix.lib.mkPoetry2Nix {pkgs = pkgs.${system};}) mkPoetryApplication;
      app = mkPoetryApplication {projectDir = ./.;};
    in {
      default = {
        type = "app";
        program = "${app}/bin/app";
      };
    });
  };
}

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
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          python3
          poetry
        ];
      };
    });

    apps = forEachSystem (system: let
      inherit (poetry2nix.lib.mkPoetry2Nix {pkgs = pkgsFor.${system};}) mkPoetryApplication;
      app = mkPoetryApplication {projectDir = ./.;};
    in {
      default = {
        type = "app";
        program = "${app}/bin/app";
      };
    });
  };
}

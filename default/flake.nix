{
  description = "Nix Flake Template for Development";

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
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgs.${system}.hello;
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.default}/bin/hello";
      };
    });
  };
}

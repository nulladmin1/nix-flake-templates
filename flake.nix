{
  description = "A collection of Nix Flake Templates";

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
  in rec{
    formatter = forEachSystem (system: pkgs.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgs.${system}.mkShell {
        packages = [
          (pkgs.${system}.python312.withPackages (python-pkgs: with python-pkgs; [
            mkdocs-material
          ]))
        ];
      };
    });

    templates = {
      default = {
        description = "Nix Flake Template for Development";
        path = ./default;
      };
      python-nix = {
        description = "Nix Flake Template for Python using builtin Nix builders";
        path = ./python-nix;
      };
      python-poetry = {
        description = "Nix Flake Template for Python using Poetry";
        path = ./python-poetry;
      };
      rust-fenix-naersk = {
        description = "Nix Flake Template for Rust using Fenix and Naersk";
        path = ./rust-fenix-naersk;
      };
      cpp-cmake = {
        description = "Nix Flake Template for C++ using CMake";
        path = ./cpp-cmake;
      };
      go-gomod2nix = {
        description = "Nix Flake Template for Go using gomod2nix";
        path = ./go-gomod2nix;
      };
      python = templates.python-poetry;
      rust = templates.rust-fenix-naersk;
      cpp = templates.cpp-cmake;
      go = templates.go-gomod2nix;
    };
  };
}

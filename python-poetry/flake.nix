{
  description = "project_name";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    poetry2nix,
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
          poetry2nix-lib = forEachSystem (system: poetry2nix.lib.mkPoetry2Nix {inherit pkgs;});
        });
  in {
    formatter = forEachSystem ({pkgs, ...}: pkgs.alejandra);

    devShells = forEachSystem ({
      pkgs,
      poetry2nix-lib,
      ...
    }: {
      default =
        (poetry2nix-lib.mkPoetryEnv {
          projectDir = ./.;
          editablePackageSources = {
            project_name = ./project_name;
          };
        })
        .env
        .overrideAttrs (oldAttrs: {
          buildInputs = with pkgs; [
            poetry
          ];
        });
    });

    apps = forEachSystem ({
      pkgs,
      poetry2nix-lib,
      ...
    }: let
      app = poetry2nix-lib.mkPoetryApplication {projectDir = ./.;};
    in {
      default = {
        type = "app";
        program = "${app}/bin/project_name";
      };
    });
  };
}

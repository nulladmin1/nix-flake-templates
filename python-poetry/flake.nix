{
  description = "Nix Flake Template for Python using Poetry";

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
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});
    poetry2nix-lib = forEachSystem(system: poetry2nix.lib.mkPoetry2Nix { pkgs = pkgsFor.${system}; });
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = (poetry2nix-lib.${system}.mkPoetryEnv {
        projectDir = ./.;
        editablePackageSources = {
          app = ./app;
        };
      }).env.overrideAttrs (oldAttrs: {
        buildInputs = with pkgsFor.${system}; [
          poetry
        ];
      });
    });

    apps = forEachSystem (system: let
      app = poetry2nix-lib.${system}.mkPoetryApplication {projectDir = ./.;};
    in {
      default = {
        type = "app";
        program = "${app}/bin/app";
      };
    });
  };
}

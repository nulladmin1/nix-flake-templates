{
  description = "A collection of Nix Flake Templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    cli = {
      url = "github:nulladmin1/getflake";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    pre-commit-hooks,
    cli,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    inherit (cli) apps;

    checks = forEachSystem (system: {
      pre-commit-run = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          actionlint.enable = true;
          alejandra.enable = true;
          editorconfig-checker.enable = true;
          statix.enable = true;
          nil.enable = true;
        };
      };
    });

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-run) shellHook;
        buildInputs = self.checks.${system}.pre-commit-run.enabledPackages;
      };
    });

    templates = {
      default = {
        description = "Nix Flake Template for Development";
        path = ./default;
      };
      go-nix = {
        description = "Nix Flake Template for Go with Nixpkgs Builders";
        path = ./go-nix;
      };
      python-nix = {
        description = "Nix Flake Template for Python using Nixpkgs builders";
        path = ./python-nix;
      };
      python-pyproject-nix = {
        description = "Nix Flake Template for Python using Pyproject-nix";
        path = ./python-pyproject-nix;
      };
      python-poetry = {
        description = "Nix Flake Template for Python using Poetry";
        path = ./python-poetry;
      };
      python-uv = {
        description = "Nix Flake Template for Python using uv2nix";
        path = ./python-uv;
      };
      rust-fenix-naersk = {
        description = "Nix Flake Template for Rust using Fenix and Naersk";
        path = ./rust-fenix-naersk;
      };
      rust-nix = {
        description = "Nix Flake Template for Rust using Nixpkgs Builders";
        path = ./rust-nix;
      };
      cpp-cmake = {
        description = "Nix Flake Template for C++ using CMake";
        path = ./cpp-cmake;
      };
      go-gomod2nix = {
        description = "Nix Flake Template for Go using gomod2nix";
        path = ./go-gomod2nix;
      };
      vimPlugins = {
        description = "Nix Flake Template for vimPlugins";
        path = ./vimPlugin;
      };
      flutter-nix = {
        description = "Nix Flake Template for Flutter using Nixpkgs Builders";
        path = ./flutter-nix;
      };
      nixpkgs = {
        description = "Nix Flake Template for Nixpkgs Development";
        path = ./nixpkgs;
      };
      bash = {
        description = "Nix Flake Template for Bash using Nixpkgs Builders";
        path = ./bash;
      };
      zig = {
        description = "Nix Flake Template for Zig using Nixpkgs Builders";
        path = ./zig;
      };
      sh = self.templates.bash;
      flutter = self.templates.flutter-nix;
      pyproject = self.templates.python-pyproject-nix;
      python = self.templates.python-nix;
      poetry = self.templates.python-poetry;
      uv = self.templates.python-uv;
      rust = self.templates.rust-fenix-naersk;
      cpp = self.templates.cpp-cmake;
      go = self.templates.go-gomod2nix;
      vim = self.templates.vimPlugins;
    };
  };
}

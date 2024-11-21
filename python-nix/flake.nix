{
  description = "Nix Flake Template for Python with builtin Nix Builders";

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
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          python311
        ] ++ (with pkgsFor.${system}.python311Packages; [
          setuptools
          pip
        ]);
      };
    });

    packages = forEachSystem (system: {
      default = pkgsFor.${system}.python311Packages.buildPythonPackage rec {
        pname = "app";
        version = "0.1.0";
        src = ./.;
        format = "pyproject";

        nativeBuildInputs = with pkgsFor.${system}.python311Packages; [
          setuptools
        ];
      };
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/app";
      };
    });
  };
}

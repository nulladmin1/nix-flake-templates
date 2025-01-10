{
  description = "Nix Flake Template for Development in Nixpkgs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
      pkgsFor = forEachSystem (system: import nixpkgs { inherit system; });
    in
    {
      formatter = forEachSystem (system: pkgsFor.${system}.nixfmt-rfc-style);

      devShells = forEachSystem (system: {
        default = pkgsFor.${system}.mkShell {
          packages = with pkgsFor.${system}; [
            nixfmt-rfc-style
          ];
        };
      });

      packages = forEachSystem (system: {
        default = pkgsFor.${system}.callPackage ./package.nix;
      });

      apps = forEachSystem (system: {
        default = {
          type = "app";
          program = pkgsFor.${system}.lib.getExe self.packages.${system}.default;
        };
      });
    };
}

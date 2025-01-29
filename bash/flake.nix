{
  description = "project_name";

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
    inherit (nixpkgs) lib;
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    devShells = forEachSystem (system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          shellcheck
          shfmt
        ];
      };
    });

    packages = forEachSystem (system: {
      default = pkgsFor.${system}.writeShellScriptBin "project_name" (builtins.readFile ./hello.sh);
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${lib.getExe self.packages.${system}.default}";
      };
    });
  };
}

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
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    checks = forEachSystem ({pkgs, ...}: {
      pre-commit-run = pre-commit-hooks.lib.${pkgs.system}.run {
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

    devShells = forEachSystem ({pkgs, ...}: {
      default = pkgs.mkShell {
        inherit (self.checks.${pkgs.system}.pre-commit-run) shellHook;
        buildInputs = self.checks.${pkgs.system}.pre-commit-run.enabledPackages;
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
      bevy = {
        description = "Nix Flake Template for Bevy using Fenix and Crane";
        path = ./bevy;
      };
      rust-fenix-crane = {
        description = "Nix Flake Template for Rust using Fenix and Crane";
        path = ./rust-fenix-crane;
      };
      rust-iced = {
        description = "Nix Flake Template for Iced";
        path = ./rust-iced;
      };
      iced = self.templates.rust-iced;
      iced-rs = self.templates.rust-iced;
      crane = self.templates.rust-fenix-crane;
      sh = self.templates.bash;
      flutter = self.templates.flutter-nix;
      pyproject = self.templates.python-pyproject-nix;
      python = self.templates.python-nix;
      poetry = self.templates.python-poetry;
      uv = self.templates.python-uv;
      rust = self.templates.rust-fenix-crane;
      cpp = self.templates.cpp-cmake;
      go = self.templates.go-gomod2nix;
      vim = self.templates.vimPlugins;
    };

    apps = forEachSystem ({pkgs, ...}: let
      inherit (pkgs.lib) getExe;
      jq = getExe pkgs.jq;
      prettier = getExe pkgs.nodePackages.prettier;
    in
      cli.apps.${pkgs.system}
      // {
        makeTable = {
          type = "app";
          program = getExe (pkgs.writeShellScriptBin "makeTable" ''
            flake_templates=$(nix flake show --json | ${jq} '.templates')

            table="| Type Keyword | Type | Subdirectory | Documentation |
            |--------------|------|--------------|--------------|"

            declare -A type_map
            declare -A keywords_map

            while IFS='@' read -r key desc; do
              desc=$(echo "$desc" | xargs)

              if [[ -z "''${type_map[$desc]:-}" ]] || [[ ''${#key} -gt ''${#type_map[$desc]} ]]; then
                  type_map["$desc"]="$key"
              fi

              if [[ -z "''${keywords_map[$desc]:-}" ]]; then
                  keywords_map["$desc"]="\`$key\`"
              else
                  keywords_map["$desc"]="''${keywords_map[$desc]}, \`$key\`"
              fi
            done < <(echo "$flake_templates" | ${jq} -r 'to_entries | sort_by(.value.description)[] | "\(.key)@\(.value.description | sub("^Nix Flake Template for "; ""))"')

            mapfile -t sorted_descriptions < <(printf "%s\n" "''${!type_map[@]}" | sort)

            for desc in "''${sorted_descriptions[@]}"; do
                keywords="''${keywords_map[$desc]}"
                type="''${type_map[$desc]}"
                table+="
            | $keywords | $desc | [$type]($type) | [README]($type/README.md) |"
            done

            echo -e "$table" | ${prettier} --parser markdown
          '');
        };
      });
  };
}

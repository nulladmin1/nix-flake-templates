# Nix Flake Template for vimPlugins

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#vimPlugin"
```

This is how to structure of the template looks like:

```
📦 vimPlugin
├── ⚙️ .envrc
├── ❄️ default.nix
├── 📃 README.md
└── ❄️ flake.nix
```

The flake contains a packages output that calls the default.nix that actually houses the derivation that builds the vimPlugin.

### Build the plugin

```shell
nix build
```

### (Optional) Format [`flake.nix`](flake.nix) using `Alejandra`

```shelll
nix fmt
```

## To customize it to your own needs:

- In [`flake.nix`](flake.nix)
  - Edit description
    ```nix
    {
    	description = "project_name";
    }
    ```
  - Or just _delete_ it altogether. Make sure that when you use the plugin in another file, use `pkgs.callPackage ./default.nix {}`, not `import ./default.nix {}`. `callPackage` automatically imports it with the function parameters imported from `pkgs` (or something idk)
- In [`default.nix`](default.nix)

  - Customize the parameters:
    ```nix
    {
        vimUtils,
        fetchFromGitHub,
    }:
    ```
  - Change the derivation details:

    ```nix
      name = "project_name";

      src = fetchFromGitHub {
      };
    ```

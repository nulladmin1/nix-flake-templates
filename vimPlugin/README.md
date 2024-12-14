# Nix Flake Template for vimPlugins

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#vimPlugin"
```

The flake contains a packages output that calls the default.nix that actually houses the derivation that builds the vimPlugin. In this template, I have included a vimPlugin for [`Notion.nvim`](https://github.com/Al0den/notion.nvim). You _probably_ want to just delete the flake.nix files and use or copy the contents of the default.nix file.

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
    	description = "Nix Flake Template for vimPlugins";
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
      name = "notion";

      src = fetchFromGitHub {
          owner = "Al0den";
          repo = "notion.nvim";
          rev = "a72d555da8a09ec92323181ac7f2c5c3b92658ee";
          hash = "sha256-8H+Y8xLat7XnWFMGErtkvJj1WfMAf07/qBGT7nrIG6I=";
      };
    ```

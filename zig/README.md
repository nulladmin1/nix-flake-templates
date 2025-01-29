# Nix Flake Template for Zig using Nixpkgs Builders

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#zig"
```

The flake is able to run in the specified systems listed in the flake. It contains a `devShells` as an output with `Zig`, a package that runs `hello` by building it with Nixpkgs' `zig.hook`, and an app that runs the previously mentioned package.

### Run using Nix

```shell
nix run
```

### Go into Development Shell

```shell
nix develop
```

### (Optional) Format [`flake.nix`](flake.nix) using `Alejandra`

```shelll
nix fmt
```

## To customize it to you own needs:

- In ['flake.nix'](flake.nix)

  - Edit description
    ```nix
    {
        description = "project_name";
    }
    ```
  - Change details in `mkDerivation`

    ```nix
        default = pkgsFor.${system}.stdenv.mkDerivation {
        pname = "project_name";
        version = "0.1.0";
        src = ./.;

        nativeBuildInputs = with pkgsFor.${system}; [
          zig.hook
        ];
      };
    ```

- In [`build.zig`](build.zig)
  - Configure main executable details
    ```zig
        const exe = b.addExecutable(.{
          .name = "project_name",
          .root_source_file = b.path("src/main.zig"),
          .target = target,
          .optimize = optimize,
        });
    ```
- In [`build.zig.zon`](build.zig.zon)

  - Configure package details
    ```zon
      .name = "project_name",
      .version = "0.1.0",
    ```

- For the structure and code
  - Add necessary code into the [`src/`](src) directory. Reflect changes in `build.zig`

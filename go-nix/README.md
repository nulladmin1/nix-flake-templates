# Nix Flake Template for Go with Nixpkgs Builders

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#go-nix"
```

This is how the structure of the template looks like:

```
📦 go-nix
├─ 📁
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 🐹 go.mod
├─ 🐹 main.go
└─ 📃 README.md
```

It includes a basic Go project that prints Hello World!

It contains a `devShell` with `go`, and an app that prints Hello World

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

## To customize it to your own needs:

- In [`flake.nix`](flake.nix)

  - Edit description

  ```nix
        {
            description = "project_name";
        # ...
        }
  ```

  - Change project details in the default packages.

  ```nix
        default = pkgsFor.${system}.buildGoModule {
            pname = "project_name";
            version = "0.1.0";
            src = ./.;
            # ...
      };
  ```

  - Change the hash after finishing a published change

  ```nix
       default = pkgsFor.${system}.buildGoModule {
           #...
           vendorHash = null;
       };
  ```

- In [`go.mod`](go.mod)
  - Change modules and Go version
  ```go
            module project_name
            go 1.22.7
  ```
- For structure and code
  - Add source files and reflect changes in `go.mod`
  - Be sure to change the `vendorHash` (like previously stated)

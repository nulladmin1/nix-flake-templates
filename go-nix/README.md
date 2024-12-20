# Nix Flake Template for Go with builtin Nix Builders

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#go-nix"
```

This is how the structure of the template looks like:

```
📦 go-gomod2nix
├─ 📁 src
│  └─ 🐹 hello.go
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 🐹 go.mod
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
            description = "Nix Flake Template for Go with builtin Nix Builders";
        # ...
        }
  ```

  - Change project details in the default packages.

  ```nix
        default = pkgsFor.${system}.buildGoModule {
            pname = "hello";
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
            module hello
            go 1.22.7
  ```
- For structure and code
  - Add necessary code for the program in the src/ directory. Reflect changes in `go.mod`
  - Be sure to change the `vendorHash` (like previously stated)

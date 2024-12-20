# Nix Flake Template for Go using Gomod2nix

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#go"
```

or

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#go-gomod2nix"
```

This is how the structure of the template looks like:

```
📦 go-gomod2nix
├─ 📁 src
│  └─ 🐹 hello.go
├─ 🙈 .gitignore
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 🐹 go.mod
├─ ⚙️ gomod2nix.toml
├─ 📃 README.md
```

It includes a basic Go project that prints Hello World!

It contains a `devShells` with this projects `goEnv` and the `gomod2nix` tool, and an app that prints Hello World

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
            description = "Nix Flake Template for Go using GoMod2Nix";
        # ...
        }
  ```
  - Change project details in the default packages
  ```nix
            default = pkgs.${system}.buildGoApplication {
                pname = "hello";
                version = "0.1.0";
                pwd = ./.;
                src = ./.;
                modules = ./gomod2nix.toml;
            };
  ```
- In [`go.mod`](go.mod)
  - Change modules and Go version
  ```vgo
            module hello
            go 1.22.7
  ```
- For structure and code
  - Add necessary code for the program in the src/ directory. Reflect changes in `go.mod`
  - Generate new [`gomod2nix.toml`](gomod2nix.toml) by:
    - Going into development shell
      ```shell
            nix develop
      ```
    - Running the tool
      ```shell
            gomod2nix generate
      ```


# Nix Flake Template (Default)

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates"
```

OR

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#default"
```

This is how the structure of the template looks like

```
📦 default
├── ⚙️ .envrc
├── 📃 README.md
└── ❄️ flake.nix
```

The flake is able to run in the specified systems listed in the flake. It contains a `devShells` as an output with `hello`, a package that runs `hello` from Nixpkgs, and an app that runs the previously mentioned package.

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

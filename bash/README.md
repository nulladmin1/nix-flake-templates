# Nix Flake Template (Default)

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#bash"
```

OR

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#sh"
```

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

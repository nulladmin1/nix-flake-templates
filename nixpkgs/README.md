# Nix Flake Template for Nixpkgs dev

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#nixpkgs"
```

This flake provides a really simple flake to be used when making `Nixpkgs` packages. It has the `nixfmt-rfc-style` formatter used in `nixpkgs`, and a package and app declaration using for building and executing the [package.nix](./package.nix) file.

### Run using Nix

```shell
nix run
```

### Go into Development Shell

```shell
nix develop
```

### (Optional) Format [`flake.nix`](flake.nix) using `nixfmt-rfc-style`

```shelll
nix fmt
```

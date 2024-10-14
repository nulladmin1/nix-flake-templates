# Nix Flake Template (Default)

*All of this information is also included in the [README.md](../README.md)*

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates"
```
or
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#default"
```

The flake is able to run in the specified systems listed in the flake. It contains a ```devShell``` as an output with ```hello```, a package that runs ```hello``` from Nixpkgs, and an app that runs the previously mentioned package.

#### Run using Nix
```shell
nix run
```

#### Go into Development Shell
```shell
nix develop
```

#### (Optional) Format ```flake.nix``` using ```Alejandra```
```shelll
nix fmt
```

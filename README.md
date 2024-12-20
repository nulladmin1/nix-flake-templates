# Nix Flake Templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com)

A collection of Nix Flake Templates

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#${TYPE}"
```

Where `${TYPE}` is the supported type of template:

| Type                                | Subdirectory                                 | Documentation                            |
| ----------------------------------- | -------------------------------------------- | ---------------------------------------- |
| _Default_                           | [default](default)                           | [default](default/README.md)             |
| Python (using `poetry2nix`)         | [python-poetry](python-poetry)               | [README](python-poetry/README.md)        |
| Python (using `pyproject-nix`)      | [python-pyproject-nix](python-pyproject-nix) | [README](python-pyproject-nix/README.md) |
| Python (using builtin Nix builders) | [python-nix](python-nix)                     | [README](python-nix/README.md)           |
| Python (using `uv2nix`)             | [python-uv](python-uv)                       | [README](python-uv/README.md)            |
| Go (using builtin Nix builders)     | [go-nix](go-nix)                             | [README](go-nix/README.md)               |
| Go (using `gomod2nix`               | [go-gomod2nix](go-gomod2nix)                 | [README](go-gomod2nix/README.md)         |
| Rust (using `fenix` and `naersk`)   | [rust-fenix-naersk](rust-fenix-naersk)       | [README](rust-fenix-naersk/README.md)    |
| C++ (using `CMake`)                 | [cpp-cmake](cpp-cmake)                       | [README](cpp-cmake/README.md)            |

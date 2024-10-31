# Nix Flake Templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com)

A collection of Nix Flake Templates

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#${LANG}"
```

Where ```${LANG}``` is the supported language:

| Language                                  | Subdirectory                           | Documentation                         |
|-------------------------------------------|----------------------------------------|---------------------------------------|
| _Default_                                 | [default](default)                     | [default](default/README.md)          |
| Python (using ```poetry2nix```)           | [python-poetry](python-poetry)         | [README](python-poetry/README.md)     |
| Go (using ```gomod2nix```                 | [go-gomod2nix](go-gomod2nix)           | [README](go-gomod2nix/README.md)      |
| Rust (using ```fenix``` and ```naersk```) | [rust-fenix-naersk](rust-fenix-naersk) | [README](rust-fenix-naersk/README.md) |
| C++ (using ```CMake```)                   | [cpp-cmake](cpp-cmake)                 | [README](cpp-cmake/README.md)         |

# Nix Flake Templates Wiki

A collection of Nix Flake Templates

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#${LANG}"
```

Where ```${LANG}``` is the supported language:

| Language                                  | Subdirectory                                                                                      | Documentation                         |
|-------------------------------------------|---------------------------------------------------------------------------------------------------|---------------------------------------|
| _Default_                                 | [default](https://github.com/nulladmin1/nix-flake-templates/tree/main/default)                    | [default]()                           |
| Python (using ```poetry2nix```)           | [python-poetry](https://github.com/nulladmin1/nix-flake-templates/tree/main/python-poetry)        | [README](python-poetry/README.md)     |
| Python (using builtin Nix builders)       | [python-nix](https://github.com/nulladmin1/nix-flake-templates/tree/main/python-nix)              |  [README](python-nix/README.md)       |
| Python (using ```uv2nix```)               | [python-uv](https://github.com/nulladmin1/nix-flake-templates/tree/main/python-uv)                | [README](python-uv/README.md)         |
| Go (using ```gomod2nix```                 | [go-gomod2nix](https://github.com/nulladmin1/nix-flake-templates/tree/main/go-gomod2nix)          | [README](go-gomod2nix/README.md)      |
| Rust (using ```fenix``` and ```naersk```) | [rust-fenix-naersk](https://github.com/nulladmin1/nix-flake-templates/tree/main/rust-fenix-naersk)| [README](rust-fenix-naersk/README.md) |
| C++ (using ```CMake```)                   | [cpp-cmake](https://github.com/nulladmin1/nix-flake-templates/tree/main/cpp-cmake)                | [README](cpp-cmake/README.md)         |


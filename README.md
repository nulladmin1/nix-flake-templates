# ❄️ Nix Flake Templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com)

A collection of Nix Flake Templates

![demo](./demo.gif)

## Table of Contents

- [Usage](#usage)
- [Examples](#examples)

## Usage

Use [`getflake`](https://github.com/nulladmin1/getflake) to initialize flake (recommended)

```shell
nix run github:nulladmin1/getflake
```

Or initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#${TYPE_KEYWORD}"
```

Where `${TYPE_KEYWORD}` is the supported type keyword of template:

| Type Keyword                 | Type                                 | Subdirectory                                 | Documentation                            |
| ---------------------------- | ------------------------------------ | -------------------------------------------- | ---------------------------------------- |
| _empty_, `default`           | _Default_                            | [default](default)                           | [default](default/README.md)             |
| `nixpkgs`                    | Nixpkgs                              | [nixpkgs](nixpkgs)                           | [README](nixpkgs/README.md)              |
| `poetry`, `python-poetry`    | Python (using `poetry2nix`)          | [python-poetry](python-poetry)               | [README](python-poetry/README.md)        |
| `pyproject`, `pyproject-nix` | Python (using `pyproject-nix`)       | [python-pyproject-nix](python-pyproject-nix) | [README](python-pyproject-nix/README.md) |
| `python`, `python-nix`       | Python (using Nixpkgs builders)      | [python-nix](python-nix)                     | [README](python-nix/README.md)           |
| `uv`, `python-uv`            | Python (using `uv2nix`)              | [python-uv](python-uv)                       | [README](python-uv/README.md)            |
| `go-nix`                     | Go (using Nixpkgs builders)          | [go-nix](go-nix)                             | [README](go-nix/README.md)               |
| `go`, `go-gomod2nix`         | Go (using `gomod2nix`                | [go-gomod2nix](go-gomod2nix)                 | [README](go-gomod2nix/README.md)         |
| `rust`, `rust-fenix-naersk`  | Rust (using `fenix` and `naersk`)    | [rust-fenix-naersk](rust-fenix-naersk)       | [README](rust-fenix-naersk/README.md)    |
| `rust-nix`                   | Rust (using Nixpkgs builders)        | [rust-nix](rust-nix)                         | [README](rust-nix/README.md)             |
| `cpp`, `cpp-cmake`           | C++ (using `CMake`)                  | [cpp-cmake](cpp-cmake)                       | [README](cpp-cmake/README.md)            |
| `vim`                        | Vim Plugins (using Nixpkgs builders) | [vimPlugin](vimPlugin)                       | [README](vimPlugin/README.md)            |
| `flutter`, `flutter-nix`     | Flutter (using Nixpkgs builders)     | [flutter-nix](flutter-nix)                   | [README](flutter-nix/README.md)          |
| `bash`, `sh`                 | Bash (using Nixpkgs builders)        | [bash](bash)                                 | [README](bash/README.md)                 |
| `zig`                        | Zig (using Nixpkgs builders)         | [zig](zig)                                   | [README](zig/README.md)                  |

## Examples

[`getflake`](https://github.com/nulladmin1/getflake) (using `rust-fenix-naersk`) - A simple to program to automatically instantiate my [Nix-Flake-Templates](https://github.com/nulladmin1/nix-flake-templates)

[`eightQueens`](https://github.com/nulladmin1/eightQueens) (using `cpp-cmake`) - A rendition of the famous [Eight Queens Puzzle](https://en.wikipedia.org/wiki/Eight_queens_puzzle) in `C++`

[`mp2ExtraCredit`](https://github.com/nulladmin1/eightQueens) (using `cpp-cmake`) - A solution of a plague simulation I had to do for Computer Science II, in `C++`

[`josephus-rs`](https://github.com/nulladmin1/josephus-rs) (using `rust-fenix-naersk`) - An implementation of the [Josephus problem](https://en.wikipedia.org/wiki/Josephus_problem) in `Rust`

[`sha256_python_with_tests`](examples/sha256_python_with_tests) - A simple Python program with testcases to encode a user-inputted string in SHA256

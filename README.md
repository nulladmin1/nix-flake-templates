# ❄️ Nix Flake Templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com)

A collection of Nix Flake Templates

![demo](./demo.gif)

**Contributors, go to [CONTRIBUTING.md](./CONTRIBUTING.md)**

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

| Type Keyword                        | Type                           | Subdirectory                                 | Documentation                            |
| ----------------------------------- | ------------------------------ | -------------------------------------------- | ---------------------------------------- |
| `bash`, `sh`                        | Bash using Nixpkgs Builders    | [bash](bash)                                 | [README](bash/README.md)                 |
| `bevy`                              | Bevy using Fenix and Crane     | [bevy](bevy)                                 | [README](bevy/README.md)                 |
| `cpp`, `cpp-cmake`                  | C++ using CMake                | [cpp-cmake](cpp-cmake)                       | [README](cpp-cmake/README.md)            |
| `default`                           | Development                    | [default](default)                           | [README](default/README.md)              |
| `flutter`, `flutter-nix`            | Flutter using Nixpkgs Builders | [flutter-nix](flutter-nix)                   | [README](flutter-nix/README.md)          |
| `go`, `go-gomod2nix`                | Go using gomod2nix             | [go-gomod2nix](go-gomod2nix)                 | [README](go-gomod2nix/README.md)         |
| `go-nix`                            | Go with Nixpkgs Builders       | [go-nix](go-nix)                             | [README](go-nix/README.md)               |
| `nixpkgs`                           | Nixpkgs Development            | [nixpkgs](nixpkgs)                           | [README](nixpkgs/README.md)              |
| `python`, `python-nix`              | Python using Nixpkgs builders  | [python-nix](python-nix)                     | [README](python-nix/README.md)           |
| `poetry`, `python-poetry`           | Python using Poetry            | [python-poetry](python-poetry)               | [README](python-poetry/README.md)        |
| `pyproject`, `python-pyproject-nix` | Python using Pyproject-nix     | [python-pyproject-nix](python-pyproject-nix) | [README](python-pyproject-nix/README.md) |
| `python-uv`, `uv`                   | Python using uv2nix            | [python-uv](python-uv)                       | [README](python-uv/README.md)            |
| `crane`, `rust`, `rust-fenix-crane` | Rust using Fenix and Crane     | [rust-fenix-crane](rust-fenix-crane)         | [README](rust-fenix-crane/README.md)     |
| `rust-fenix-naersk`                 | Rust using Fenix and Naersk    | [rust-fenix-naersk](rust-fenix-naersk)       | [README](rust-fenix-naersk/README.md)    |
| `rust-nix`                          | Rust using Nixpkgs Builders    | [rust-nix](rust-nix)                         | [README](rust-nix/README.md)             |
| `vim`, `vimPlugins`                 | vimPlugins                     | [vimPlugins](vimPlugins)                     | [README](vimPlugins/README.md)           |
| `zig`                               | Zig using Nixpkgs Builders     | [zig](zig)                                   | [README](zig/README.md)                  |

## Examples

[`getflake`](https://github.com/nulladmin1/getflake) (using `rust-fenix-naersk`) - A simple to program to automatically instantiate my [Nix-Flake-Templates](https://github.com/nulladmin1/nix-flake-templates)

[`eightQueens`](https://github.com/nulladmin1/eightQueens) (using `cpp-cmake`) - A rendition of the famous [Eight Queens Puzzle](https://en.wikipedia.org/wiki/Eight_queens_puzzle) in `C++`

[`mp2ExtraCredit`](https://github.com/nulladmin1/eightQueens) (using `cpp-cmake`) - A solution of a plague simulation I had to do for Computer Science II, in `C++`

[`josephus-rs`](https://github.com/nulladmin1/josephus-rs) (using `rust-fenix-naersk`) - An implementation of the [Josephus problem](https://en.wikipedia.org/wiki/Josephus_problem) in `Rust`

[`sha256_python_with_tests`](examples/sha256_python_with_tests) - A simple Python program with testcases to encode a user-inputted string in SHA256

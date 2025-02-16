# Nix Flake Template for Rust using Fenix and Naersk

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#rust-fenix-naersk"
```

This is how to structure of the template looks like:

```
📦 rust-fenix-naersk
├── ⚙️ .envrc
├── 🙈 .gitignore
├── 🔒 Cargo.lock
├── ⚙️ Cargo.toml
├── 📃 README.md
├── ❄️ flake.nix
└── 📁 src
    └── 🦀 main.rs
```

It includes a really simple Hello World program

### Run using `naersk` (Recommended)

Run app

```shell
nix run
```

### Run using `Cargo`

Drop into a development shell

```shell
nix develop
```

Run app

```shell
cargo run
```

### (Optional) Format [`flake.nix`](flake.nix) using `Alejandra`

```shelll
nix fmt
```

## To customize it to your own needs

- In [`flake.nix`](flake.nix)

  - Edit description
    ```nix
    {
        description = "project_name";
    }
    ```
  - Change the name of the binary

  ```nix
  {
        program = "${self.packages.${system}.default}/bin/project_name";
  }
  ```

- In [`Cargo.toml`](Cargo.toml)

  - Change name, version, edition, etc.

  ```toml
  	[package]
  	name = "project_name"
  	version = "0.1.0"
  	edition = "2021"
  ```

- For the structure and code
  - Add necessary code into the [`src/`](src) directory

# Nix Flake Template for C++ using

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#cpp-cmake"
```

OR
Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#cpp"
```

This is how the structure of the template looks like:

```
📦 cpp-cmake
├── ⚙️ .envrc
├── 🙈 .gitignore
├── ⚙️ CMakeLists.txt
├── 📃 README.md
├── ❄️ flake.nix
└── src
    ├── ⚙️ CMakeLists.txt
    └── 📝 hello.cpp
```

It includes a really simple Hello World program

### Run using Nix

```shell
nix run
```

### Go into Development Shell

```shell
nix develop
```

### (Optional) Format [`flake.nix`](flake.nix) using `Alejandra`

```shell
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
- For the structure and code
  - Add necessary code into the [`src/`](src) directory and configure CMake accordingly

# Nix Flake Template for Python using `pyproject-nix`

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#python-pyproject-nix"
```

OR

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#pyproject"
```

This is how the structure of the template looks like:

```
📦 python-pyproject-nix
├─ 📁 app
│  ├─ 🐍 __init__.py
│  └─ 🐍 main.py
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ ⚙️ pyproject.toml
├─ 📃 README.md
└─ 📁 tests
   └─ 🐍 test_main.py
```

It includes a basic Python project that returns an SHA256 encoded string of the user's input. It has a testcase that can be run using `Pytest` or `unittest`.

The flake is able to run in the specified systems listed in the flake. It contains a `devShells` as an output with a `pythonEnv` that contains all project dependencies, and an app as an output that builds a Python project using `pyproject-nix`'s '`buildPythonPackage` renderer.

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

## To customize it to your own needs:

- In ['flake.nix'](flake.nix)
  - Edit description
    ```nix
    {
        description = "Nix Flake Template for Python using pyproject-nix";
    }
    ```
  - Change Python version if necessary
    ```nix
    python = forEachSystem (system: pkgsFor.${system}.python312);
    ```
  - Change devShell dependencies
    ```nix
    {
    pkgsFor.${system}.mkShell {
        packages = [
          pythonEnv
        ];
      };
    }
    ```
  - Change executable name for app
    ```nix
    program = "${self.packages.${system}.default}/bin/app";
    ```
- In [`pyproject.toml`](pyproject.toml)
  - Change project details accordingly
    ```toml
    [project]
    name = "app"
    version = "0.1.0"
    description = ""
    authors = [
        {name = "Your Name", email = "you@example.com"},
    ]
    ```
  - Change Python version accordingly
    ```toml
    requires-python = ">= 3.11"
    ```
  - Add necessary and optional build dependencies

    ```toml
    dependencies = [
    ]

    [project.optional-dependencies]
    test = [
    "pytest"
    ]
    ```

  - Change the name and path of scripts if needed
    ```toml
    [project.scripts]
    app = "app:main"
    ```
- For the structure and code
  - Rename the [`app/`](app) directory to the name of your project. Make sure its the same as the path in the [`pyproject.toml`](pyproject.toml)
    ```
    📦 python-pyproject-nix
    ├─ 📁 app
    │  ├─ 🐍 __init__.py
    │  └─ 🐍 main.py
    ```
  - Add necessary code for the program in the previous subdirectory.
  - Make sure that for the [`__init__.py`](app/__init__.py), that it imports from the name of your project, and it imports the necessary functions to be used as a library
    ```python
    from app.main import main, get_sha256
    ```
  - Add necessary test cases and modifications in the [`tests/`](tests) subdirectory. Prepend all added files in that subdirectory with `test_`
  - Make sure that for the [`test_main.py`](tests/test_main.py), that it imports from the name of your project, and it imports the necessary functions for testing
    ```python
    from app.main import main, get_sha256
    ```

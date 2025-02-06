# Nix Flake Template for Python using UV

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#uv"
```

OR

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#python-uv"
```

**Heavily inspired by the [official `uv2nix` docs](https://adisbladis.github.io/uv2nix/usage/hello-world.html)**

This is how the structure of the template looks like:

```
📦 python-poetry
├── ⚙️ .envrc
├── 🙈 .gitignore
├── 📃 README.md
├── ❄️ flake.nix
├── 📁 project_name
│   ├── 🐍 __init__.py
│   └── 🐍 main.py
├── ⚙️ pyproject.toml
└── 🔒uv.lock
```

It includes a basic Python project that returns an SHA256 encoded string of the user's input.

The flake is able to run in the specified systems listed in the flake. It contains a `devShells` as an output with `Python`,`Setuptools` and `Pip`, and an app as an output that builds a Python project using `buildPythonPackage`.

### Run using `uv2nix`

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
        description = "project_name";
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
    description = "Add your description here"
    readme = "README.md"
    dependencies = []
    ```
  - Change Python version accordingly
    ```toml
    requires-python = ">=3.12"
    ```
  - Add necessary and optional build dependencies
    ```toml
    [tool.uv]
    dev-dependencies = [
    "pytest>=8.3.3",
    ]
    ```
    The best way to add dependencies would be using
    ```shell
    uv add DEPENDENCY
    ```
    Likewise, the best way to remove dependencies would be using
    ```shell
    uv remove DEPENDENCY
    ```
    Adding or removing `dev` dependencies would require adding the `--dev` option
  - Change the name and path of scripts if needed. These can be run by `uv run script_name`
    ```toml
    [project.scripts]
    app = "app:main"
    ```
  - Change the build-system if needed (`Hatchling` is good enough, however `uv` will definitely come out with it's own build system in the future)
    ```toml
    [build-system]
    requires = ["hatchling"]
    build-backend = "hatchling.build"
    ```
- For the structure and code
  - Rename the [`app/`](app) directory to the name of your project. Make sure it's the same as the path in the [`pyproject.toml`](pyproject.toml)
    ```
    📦 python-uv
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

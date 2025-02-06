# Nix Flake Template for Python using Poetry

_All this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#python-poetry"
```

OR
Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#poetry"
```

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
└── ⚙️ pyproject.toml
```

It includes a basic Poetry project that returns an SHA256 encoded string of the user's input.

The flake is able to run in the specified systems listed in the flake. It contains a `devShells` as an output with `Python` and `Poetry`, and an app as an output that builds a `Poetry` project using `poetry2nix`. This section is inspired by the [official docs for `poetry2nix`](https://github.com/nix-community/poetry2nix)

### Run using `poetry2nix` (Recommended)

Run app

```shell
nix run
```

### Run using `Poetry`

Drop into a development shell

```shell
nix develop
```

Install project and its dependencies

```shell
poetry install
```

Run app

```shell
poetry run app
```

### Test using `Pytest`

Drop into a development shell

```shell
nix develop
```

Install project and its dependencies

```shell
poetry install
```

Run Pytest

```shell
poetry run pytest
```

### (Optional) Format [`flake.nix`](flake.nix) using `Alejandra`

```shelll
nix fmt
```

## To customize it to your own needs:

- In [`flake.nix`](flake.nix)
  - Edit description
    ```nix
    {
    	description = "project_name";
    }
    ```
  - Update the location of the binary
    ```nix
    {
    	 program = "${app}/bin/project_name";
    }
    ```
- In [`pyproject.toml`](pyproject.toml)

  - Change name, version, description, and authors of the project
    ```toml
    [tool.poetry]
    name = "project_name"
    version = "0.1.0"
    description = ""
    authors = ["Your Name <you@example.com>"]
    ```
  - Remove and add needed dependencies using `poetry add ...`

    ```toml
    [tool.poetry.dependencies]
    python = "^3.12"


    [tool.poetry.group.dev.dependencies]
    pytest = "^8.3.3"
    ```

  - Change the name of the scripts and path
    ```toml
    [tool.poetry.scripts]
    project_name = "project_name.main:main"
    ```

- For the structure and code
  - Rename the [`app/`](app) directory to the name of your project. Make sure its the same as the path in the [`pyproject.toml`](pyproject.toml)
    ```
    📦 python-poetry
    ├─ 📁 project_name
    │  ├─ 🐍 __init__.py
    │  └─ 🐍 main.py
    ```
  - Add necessary code for the program in the previous subdirectory.
  - Make sure that for the [`__init__.py`](project_name/__init__.py), that it imports from the name of your project, and it imports the necessary functions to be used as a library
    ```python
    from project_name.main import main, get_sha256
    ```
- Execution
  - If running the project using `Poetry`, run using:
    ```shell
    poetry run PROJECT_NAME
    ```
    where PROJECT_NAME is the name of the project. Make sure it matches the name of the script in the [`pyproject.toml`](pyproject.toml)
    ```toml
    [tool.poetry.scripts]
    PROJECT_NAME = "PROJECT_DIR.main:main"
    ```
    where ${PROJECT_NAME} is the name of the project, and the ${PROJECT_DIR} is the location of the project (recommended to be the same as the PROJECT_NAME). By default it's: [`app/`](app)

# Nix Flake Templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com)

A collection of Nix Flake Templates


Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#${LANG}"
```

Where ```${LANG}``` is the supported language:

- Default
- Python (with Poetry and ```poetry2nix```)

## Available Templates

### [Default](default)

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates"
```
or
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#default"
```

The flake is able to run in the specified systems listed in the flake. It contains a ```devShell``` as an output with ```hello```, a package that runs ```hello``` from Nixpkgs, and an app that runs the previously mentioned package.

#### Run using Nix
```shell
nix run
```

#### Go into Development Shell
```shell
nix develop
```

#### (Optional) Format [`flake.nix`](default/flake.nix) using ```Alejandra```
```shelll
nix fmt
```

------------------
### Python (with Poetry and ```poetry2nix```)

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#python-poetry"
```

This is how the structure of the template looks like:
```
📦 python-poetry
├─ 📁 app
│  ├─ 🐍 __init__.py
│  └─ 🐍 main.py
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 🔒 poetry.lock
├─ ⚙️ pyproject.toml
├─ 📃 README.md
└─ 📁 tests
   └─ 🐍 test_main.py
 ```
 
 It includes a basic Poetry project that returns an SHA256 encoded string of the user's input. It has a testcase that can be run using ```Pytest``` or ```unittest```.
 
 The flake is able to run in the specified systems listed in the flake. It contains a ```devShel``` as an output with ```Python``` and ```Poetry```, and an app as an output that builds a ```Poetry``` project using ```poetry2nix```. This section is inspired by the [official docs for ```poetry2nix```](https://github.com/nix-community/poetry2nix)

#### Run using ```poetry2nix``` (Recommended)

Run app
```shell
nix run
```
 
 #### Run using ```Poetry```
 
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

#### Test using ```Pytest```

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

#### (Optional) Format [`flake.nix`](python-poetry/flake.nix) using ```Alejandra```
```shelll
nix fmt
```


#### To customize it to your own needs:

* In [`flake.nix`](python-poetry/flake.nix)
	* Edit description
		```nix
		{
			description = "Nix Flake Template for Python using Poetry";
		}	
		```
	* Change name of the Poetry Application (In this example, it's called app)
		```nix
		{
			app = mkPoetryApplication {projectDir = ./.;};
		}
		```
	* Change the name of the Poetry Application and the location of its binary (In this example, both are called app)
		```nix
		{
			 program = "${app}/bin/app";
		}
		```
* In [`pyproject.toml`](python-poetry/pyproject.toml)
	* Change name, version, description, and authors of the project
		```toml
		[tool.poetry]
		name = "app"
		version = "0.1.0"
		description = ""
		authors = ["Your Name <you@example.com>"]
		```
	* Remove and add needed dependencies using ```shell poetry add ...```
		```toml		
		[tool.poetry.dependencies]
		python = "^3.12"
		
		
		[tool.poetry.group.dev.dependencies]
		pytest = "^8.3.3"
		```
	* Change the name of the scripts and path
		```toml
		[tool.poetry.scripts]
		app = "app.main:main"
		```
* For the structure and code
	* Rename the [`app/`](python-poetry/app) directory to the name of your project. Make sure its the same as the path in the ```pyproject.toml```
		```
		📦 python-poetry
		└─ 📁 app
		   ├─ 🐍 __init__.py
		   └─ 🐍 main.py
		```
	* Add necessary code for the program in the previous subdirectory. 
	* Make sure that for the [`__init__.py`](python-poetry/app/__init__.py), that it imports from the name of your project, and it imports the necessary functions to be used as a library
		```python
		from app.main import main, get_sha256
		```
	* Add necessary test cases and modifications in the [`tests/`](python-poetry/tests) subdirectory. Prepend all added files in that subdirectory with ```test_```
	* Make sure that for the [`test_main.py`](python-poetry/tests/test_main.py), that it imports from the name of your project, and it imports the necessary functions for testing
		```python
		from app.main import main, get_sha256
		```
	
* Execution
	* If running the project using ```Poetry```, run using:
		```shell
		poetry run ${PROJECT_NAME}
		```
		where ${PROJECT_NAME} is the name of the project. Make sure it matches the name of the script in the [`pyproject.toml`](python-poetry/pyproject.toml)
		```
		[tool.poetry.scripts]
		${PROJECT_NAME} = "${PROJECT_DIR}.main:main"
		```
		where ${PROJECT_NAME} is the name of the project, and the ${PROJECT_DIR} is the location of the project (recommended to be the same as the PROJECT_NAME). By default it's: [`app/`](python-poetry/app)

### Rust (with ```Naersk```)

Initialize using 
```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#rust-naersk"
```

This is how to structure of the template looks like:
```
📦 rust
├─ 🔒 Cargo.lock
├─ ⚙️ Cargo.toml
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 📁 src
│  ├─ 🦀 main.rs
├─ 📃 README.md
 ```

It includes a really simple Hello World program

#### Run using ```naersk``` (Recommended)

Run app
```shell
nix run
```

#### Run using ```Cargo```

Drop into a development shell
```shell
nix develop
```

Run app
```shell
cargo run
```

#### (Optional) Format [`flake.nix`](rust/flake.nix) using ```Alejandra```
```shelll
nix fmt
```

#### To customize it to your own needs

* In [`flake.nix`](rust/flake.nix)
  * Edit description
      ```nix
      {
          description = "Nix Flake Template for Python using Poetry";
      }	
      ``` 
  * Change the name of the binary
  ```nix
 	{
        program = "${self.packages.${system}.default}/bin/hello";
	}
	```
  
* In [`Cargo.toml`](rust/flake.nix)
  * Change name, version, edition, etc. 
  ```toml
		[package]
		name = "rust"
		version = "0.1.0"
		edition = "2021"
	```
  
* For the structure and code
  * Add necessary code into the [`src/`](rust/src) directory

### C++ (with ```CMake```)

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#cpp"
```

This is how the structure of the template looks like:
```
📦 cpp
├─ 🔒 Cargo.lock
├─ ⚙️ CMakeLists.txt
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 📁 src
│  ├─ 📝 hello.cpp
│  ├─ ⚙️ CMakeLists.txt
├─ 🔨 Makefile
├─ 📃 README.md
 ```

It includes a really simple Hello World program

#### Run using Nix

```shell
nix run
```

#### Go into Development Shell
```shell
nix develop
```

#### (Optional) Format [`flake.nix`](cpp/flake.nix) using ```Alejandra```
```shell
nix fmt
```

#### To customize it to your own needs

* In [`flake.nix`](cpp/flake.nix)
	* Edit description
  ```nix
    {
        description = "Nix Flake Template for Python using Poetry";
    }	
    ``` 
	* Change the name of the binary
  ```nix
       {
          program = "${self.packages.${system}.default}/bin/hello";
      }
    ```
* For the structure and code
	* Add necessary code into the [`src/`](cpp/src) directory and configure CMake accordingly

### Go (with ```gomod2nix```)

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#go"
```
or
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#go-gomod2nix"
```

This is how the structure of the template looks like:
```
📦 go
├─ 📁 src
│  └─ 🐹 hello.go
├─ 🙈 .gitignore
├─ 🔒 flake.lock
├─ ⚙️ flake.nix
├─ 🐹 go.mod
├─ ⚙️ gomod2nix.toml
├─ 📃 README.md
 ```

It includes a basic Go project that prints Hello World

It contains a ```devShell``` with this projects `goEnv` and the `gomod2nix` tool, and an app that prints Hello World

#### Run using Nix
```shell
nix run
```

#### Go into Development Shell
```shell
nix develop
```

#### (Optional) Format [`flake.nix`](go/flake.nix) using ```Alejandra```
```shelll
nix fmt
```

#### To customize it to your own needs:

* In [`flake.nix`](go/flake.nix)
	* Edit description
      ```nix
        {
            description = "Nix Flake Template for Go using GoMod2Nix";
        }
      ```
	* Change project details in the default packages
        ```nix
            default = pkgs.${system}.buildGoApplication {
                pname = "hello";
                version = "0.1.0";
                pwd = ./.;
                src = ./.;
                modules = ./gomod2nix.toml;
            };
        ```
* In [`go.mod`](go/go.mod)
	* Change modules and Go version
      ```vgo
            module hello
            go 1.22.7
      ```
* For structure and code
	* Add necessary code for the program in the src/ directory. Reflect changes in [`go.mod`](go/go.mod)
	* Generate new [`gomod2nix.toml`](go/gomod2nix.toml) by:
		* Going into development shell
		  ```shell
                nix develop
            ```
		* Running the tool
		  ```shell
                gomod2nix generate
            ```
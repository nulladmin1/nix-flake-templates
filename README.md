# Nix Flake Templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com)

A collection of Nix Flake Templates


Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#${LANG}"
```

Where ${LANG} is the supported language:

- Default
- Python (with Poetry and ```poetry2nix```)

## Available Templates

### Default

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates"
```
or
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#default"
```

*All of this information is also included in the [README.md](./default/README.md) of the template*

The flake is able to run in the specified systems listed in the flake. It contains a ```devShell``` as an output with ```hello```, a package that runs ```hello``` from Nixpkgs, and an app that runs the previously mentioned package.

#### Run using Nix
```shell
nix run
```

#### Go into Development Shell
```shell
nix develop
```

#### (Optional) Format ```flake.nix``` using ```Alejandra```
```shelll
nix fmt
```

------------------
### Python (with Poetry and ```poetry2nix```)

Initialize using
```shell  
nix flake init --template "github:nulladmin1/nix-flake-templates#python-poetry"
```

*All of this information is also included in the [README.md](./poetry-python/README.md) of the template*

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

#### (Optional) Format ```flake.nix``` using ```Alejandra```
```shelll
nix fmt
```


#### To customize it to your own needs:

* In ```flake.nix```
	* Edit description
		```nix
		{
			description = "Nix Flake Template for Python using Poetry";
		...
		}	
		```
	* Change name of the Poetry Application (In this example, it's called app)
		```nix
		{
		...
			app = mkPoetryApplication {projectDir = ./.;};
		...
		}
		```
	* Change the name of the Poetry Application and the location of its binary (In this example, both are called app)
		```nix
		{
		...		
			 program = "${app}/bin/app";
		...	
		}
		```
* In ```pyproject.toml```
	* Change name, version, description, and authors of the project
		```toml
		[tool.poetry]
		name = "app"
		version = "0.1.0"
		description = ""
		authors = ["Your Name <you@example.com>"]
		```
	* Remove and add needed dependencies using ```poetry add ...```
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
	* Rename the ```app/``` directory to the name of your project. Make sure its the same as the path in the ```pyproject.toml```
		```shell
		📦 python-poetry
		├─ 📁 app
		│  ├─ 🐍 __init__.py
		│  └─ 🐍 main.py
		```
	* Add necessary code for the program in the previous subdirectory. 
	* Make sure that for the ```__init__.py```, that it imports from the name of your project, and it imports the necessary functions to be used as a library
		```python
		from app.main import main, get_sha256
		```
	* Add necessary test cases and modifications in the ```tests/``` subdirectory. Prepend all added files in that subdirectory with ```test_```
	* Make sure that for the ```test_main.py```, that it imports from the name of your project, and it imports the necessary functions for testing
		```python
		from app.main import main, get_sha256
		```
	
* Execution
	* If running the project using ```Poetry```, run using:
		```shell
		poetry run ${PROJECT_NAME}
		```
		where ${PROJECT_NAME} is the name of the project. Make sure it matches the name of the script in the ```pyproject.toml```
		```
		[tool.poetry.scripts]
		${PROJECT_NAME} = "${PROJECT_DIR}.main:main"
		```
		where ${PROJECT_NAME} is the name of the project, and the ${PROJECT_DIR} is the location of the project (recommended to be the same as the PROJECT_NAME). By default it's: ```app/```


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

### Run using ```naersk``` (Recommended)

Run app
```shell
nix run
```

### Run using ```Cargo```

Drop into a development shell
```shell
nix develop
```

Run app
```shell
cargo run
```

### (Optional) Format ```flake.nix``` using ```Alejandra```
```shelll
nix fmt
```

#### To customize it to your own needs

* In ```flake.nix```
  * Edit description
      ```nix
      {
          description = "Nix Flake Template for Python using Poetry";
      ...
      }	
      ``` 
  * Change the name of the binary
  ```nix
 	{
	...		
        program = "${self.packages.${system}.default}/bin/hello";
	...	
	}
	```
  
* In ```Cargo.toml```
  * Change name, version, edition, etc. 
  ```toml
		[package]
		name = "rust"
		version = "0.1.0"
		edition = "2021"
	```
  
* For the structure and code
  * Add necessary code into the ```src/``` directory
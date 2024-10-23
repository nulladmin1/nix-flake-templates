# Nix Flake Template for Rust using Naersk

*All of this information is also included in the [README.md](../README.md)*

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
# Nix Flake Template for C++ using 

*All of this information is also included in the [README.md](../README.md)*

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

#### (Optional) Format ```flake.nix``` using ```Alejandra```
```shell
nix fmt
```

#### To customize it to your own needs

* In ```flake.nix```
  * Edit description
  ```nix
    {
        description = "Nix Flake Template for Python using Poetry";
        # ...
    }	
    ``` 
  * Change the name of the binary
  ```nix
       {
      # ...		
          program = "${self.packages.${system}.default}/bin/hello";
      # ...	
      }
    ```
* For the structure and code
  * Add necessary code into the ```src/``` directory and configure CMake accordingly
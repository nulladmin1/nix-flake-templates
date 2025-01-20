# Nix Flake Template for Flutter using builtin Nix builders

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#flutter"
```

It does not contain an existing flutter project - you have to initialize one using `flutter create .`

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

- _First_ Initialize a flutter project by running `flutter create .`
- In ['flake.nix'](flake.nix)

  - Edit description
    ```nix
    {
        description = "project_name";
    }
    ```
  - Change `Flutter SDK` version
    ```nix
    {
        flutterPackage = forEachSystem (system: pkgsFor.${system}.flutter327);
    }
    ```
  - Change package details accordingly
    _Note: changing the name of the app here doesn't change the name of the binary or the project - those are controlled by the Flutter project itself. So, don't forget to run `flutter create .`_

    ```nix
    {
        packages = forEachSystem (system: {
          default = flutterPackage.${system}.buildFlutterApplication {
            pname = "app";
            version = "0.1.0";
            src = ./.;
            dartSdk = pkgsFor.${system}.dart;
            autoDepsList = true;
            autoPubspecLock = ./pubspec.lock;
            targetFlutterPlatform = "web";
          };
          web = self.packages.${system}.default.overrideAttrs (old: {
            targetFlutterPlatform = "web";
          });
        });
    }
    ```

  - Change executable name for app
    ```nix
    program = "${self.packages.${system}.default}/bin/app";
    ```


# Nix Flake Template for Flutter using builtin Nix builders

_All of this information is also included in the [README.md](https://github.com/nulladmin1/nix-flake-templates/blob/main/flake.nix)_

Initialize using

```shell
nix flake init --template "github:nulladmin1/nix-flake-templates#flutter"
```

It includes a basic Flutter project that has `Hello World` in the middle of the screen. If you are going to use as a template, delete all the flutter-specific subdirectories and files (./app.iml, ./pubspec.lock, ./pubspec.yaml, ./analysis_options.yaml, ./ios, ./lib, ./web, ./linux, ./macos, ./android, and ./windows) and then make a new one

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
        description = "Nix Flake Template for Flutter with Nix Builders";
    }
    ```
  - Change `Flutter SDK` version
    ```nix
    {
        flutterPackage = forEachSystem (system: pkgsFor.${system}.flutter327);
    }
    ```
  - Change package details accordingly
    _Note: changing the name of the app here doesn't change the name of the binary or the project - those are controlled by the Flutter project itself. That's why its recommended to delete the existing one and make a new one_

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

- In [`pyproject.toml`](pyproject.toml)

  - Change project details accordingly

    ```yaml
    name: app
    description: "A new Flutter project."
    publish_to: "none"
    version: 0.1.0

    environment:
      sdk: ^3.5.4

    dependencies:
      flutter:
        sdk: flutter

    dev_dependencies:
      flutter_test:
        sdk: flutter
      flutter_lints: ^4.0.0

    flutter:
      uses-material-design: true
    ```

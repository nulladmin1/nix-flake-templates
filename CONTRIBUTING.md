# Contributing

## Adding a new template

1. Make sure you have forked and cloned the [repo](https://github.com/nulladmin1/nix-flake-templates)
2. Open a new branch for the template you want to upload (eg. `bash` for bash)
3. Create a new nix flake template using `nix flake new -t .#PREEXISTING_TEMPLATE TEMPLATE_NAME`
4. Add that new initial template with nothing, and commit `initial template: TEMPLATE_NAME`
5. Add all the stuff for the template, including necessary code. Make sure it follows similar conventions of all other preexisting template:
   1. Having a forEachSystem that includes all systems by default
   2. A `devShell`, `packages`, and an `apps` output
   3. `Hello, World!` in code
   4. `.envrc` for `direnv`
   5. `alejandra` as formatter (with [exceptions](./nixpkgs))
   6. Everything documented in README (see other READMES for inspo).
   7. Make sure the template keywords are in README
   8. If you want examples, add it to [examples](examples)
6. Commit all of these changes
7. Add the template and its aliases in the [parent flake](flake.nix). Make sure these match with the ones in the README
8. Run `nix run .#makeTable` to regenerate the markdown table in the [parent README](README.md)
9. Commit all of these changes and push a pull-request

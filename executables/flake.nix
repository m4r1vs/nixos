{
  description = "Collection of custom executables";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      lib = pkgs.lib;

      importScript = fileName: let
        scriptModule = import ./scripts/${fileName};
      in
        scriptModule rec {
          inherit pkgs scripts;
          lib = pkgs.lib;
        };

      scripts = lib.foldl lib.mergeAttrs {} (
        lib.mapAttrsToList (fileName: fileType: importScript fileName) (builtins.readDir ./scripts)
      );
    in {
      packages = {
        scripts = scripts;
      };
      nixosModules = [
        ./modules
      ];
    });
}

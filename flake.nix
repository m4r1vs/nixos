{
  description = "Marius' Nixos Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    executables = {
      url = "path:./executables";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:m4r1vs/nixos-06cb-009a-fingerprint-sensor?ref=24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixpad = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            ./configuration.nix
            inputs.disko.nixosModules.disko
            inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mn = import ./home;
              home-manager.extraSpecialArgs = {
                theme = import ./theme.nix;
                scripts = inputs.executables.packages.${system}.scripts;
              };
            }
            inputs.nix-index-database.nixosModules.nix-index
          ]
          ++ inputs.executables.nixosModules.${system};
      };
    };
  };
}

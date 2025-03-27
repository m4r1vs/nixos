{
  description = "Marius' Nixos Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_main.url = "github:nixos/nixpkgs?ref=master";
    nixpkgs_gimp3.url = "github:m4r1vs/nixpkgs?ref=master";
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
  };

  outputs = {disko, ...} @ inputs: {
    nixosConfigurations = {
      nixpad = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          pkgs_main = import inputs.nixpkgs_main {
            system = "x86_64-linux";
          };
          pkgs_gimp3 = import inputs.nixpkgs_gimp3 {
            system = "x86_64-linux";
          };
        };
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
          inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mn = import ./home;
          }
        ];
      };
    };
  };
}

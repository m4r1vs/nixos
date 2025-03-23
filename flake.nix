{
  description = "Marius' Nixos Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:m4r1vs/nixos-06cb-009a-fingerprint-sensor?ref=24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-06cb-009a-fingerprint-sensor,
    ...
  }: {
    nixosConfigurations = {
      nixpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
          home-manager.nixosModules.home-manager
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

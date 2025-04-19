{
  description = "Marius' Nixos Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl = {
      # Run NixOS on Windows Subsystem for Linux
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comin = {
      # GitOps
      url = "github:m4r1vs/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    slidecontrol = {
      # Google Slides remote
      url = "github:m4r1vs/slidecontrol?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # Configure programs using nix
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-06cb-009a-fingerprint-sensor = {
      # Drivers for the ThinkPad P52 fingerprint scanner
      url = "github:m4r1vs/nixos-06cb-009a-fingerprint-sensor?ref=24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      # Declare how disks are formatted and partitioned
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      # Find files exported by packages in nixpkgs
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      # Create ISO and other images from config
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      # Enable Secureboot
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-cache.niveri.dev"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-cache.niveri.dev:jg3SW6BDJ0sNlPxVu7VzXo3IYa3jKNUutfbYpcKSOB8="
    ];
  };

  outputs = {self, ...} @ inputs: let
    globalArgs = {
      username = "mn";
      git = {
        name = "Marius Niveri";
        email = "marius.niveri@gmail.com";
      };
    };
    makeTheme = import ./makeTheme.nix;
  in {
    nixosConfigurations =
      {
        nixpad = inputs.nixpkgs.lib.nixosSystem (let
          systemArgs =
            globalArgs
            // {
              system = "x86_64-linux";
              theme = makeTheme {
                primary = "green";
                secondary = "orange";
              };
              git = {
                name = "Marius Niveri";
                email = "mniveri@cc.systems";
              };
              hostname = "nixpad";
            };
        in {
          inherit (systemArgs) system;
          modules = [
            ./hosts/nixpad

            ./hosts
            ./nixpkgs.nix
            ./modules

            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.disko.nixosModules.disko
            inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager

            {config._module.args = {inherit systemArgs self inputs;};}
          ];
        });
        nixner = inputs.nixpkgs.lib.nixosSystem (let
          systemArgs =
            globalArgs
            // {
              system = "aarch64-linux";
              theme = makeTheme {
                primary = "orange";
                secondary = "green";
              };
              ipv4 = "95.217.16.168";
              ipv6 = "2a01:4f9:c013:785::1";
              hostname = "nixner";
              domain = "niveri.dev";
            };
        in {
          inherit (systemArgs) system;
          modules = [
            ./hosts/nixner

            ./hosts
            ./nixpkgs.nix
            ./modules

            inputs.comin.nixosModules.comin
            inputs.disko.nixosModules.disko
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager
            inputs.slidecontrol.nixosModules.slidecontrol-server

            {config._module.args = {inherit systemArgs self inputs;};}
          ];
        });
        desknix = inputs.nixpkgs.lib.nixosSystem (let
          systemArgs =
            globalArgs
            // {
              system = "x86_64-linux";
              theme = makeTheme {
                primary = "green";
                secondary = "orange";
              };
              hostname = "desknix";
            };
        in {
          inherit (systemArgs) system;
          modules = [
            ./hosts/desknix

            ./hosts
            ./nixpkgs.nix
            ./modules

            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.disko.nixosModules.disko
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager

            {config._module.args = {inherit systemArgs self inputs;};}
          ];
        });
        winix = inputs.nixpkgs.lib.nixosSystem (let
          systemArgs =
            globalArgs
            // {
              system = "x86_64-linux";
              theme = makeTheme {
                primary = "green";
                secondary = "orange";
              };
              hostname = "winix";
            };
        in {
          inherit (systemArgs) system;
          modules = [
            ./hosts/winix

            ./hosts
            ./nixpkgs.nix
            ./modules

            inputs.nixos-wsl.nixosModules.default
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.home-manager

            {config._module.args = {inherit systemArgs self inputs;};}
          ];
        });
      }
      // (import ./hosts/kubenix) {
        inherit inputs globalArgs self makeTheme;
        modules = [
          ./hosts
          ./nixpkgs.nix
          ./modules
          inputs.comin.nixosModules.comin
          inputs.disko.nixosModules.disko
          inputs.nix-index-database.nixosModules.nix-index
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    packages.x86_64-linux = {
      bootstrap_local_x86_64 = inputs.nixos-generators.nixosGenerate (let
        systemArgs =
          globalArgs
          // {
            username = "nixos";
            system = "x86_64-linux";
            theme = makeTheme {
              primary = "green";
              secondary = "orange";
            };
            hostname = "nixiso";
            format = "install-iso";
          };
      in {
        inherit (systemArgs) format system;
        modules = [
          ./bootstrap/local.nix

          ./hosts
          ./nixpkgs.nix
          ./modules

          inputs.home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.nix-index

          {config._module.args = {inherit systemArgs self inputs;};}
        ];
      });
      bootstrap_remote_arm64 = inputs.nixos-generators.nixosGenerate (let
        systemArgs =
          globalArgs
          // {
            username = "nixos";
            system = "aarch64-linux";
            theme = makeTheme {
              primary = "green";
              secondary = "orange";
            };
            hostname = "nixiso_remote_arm";
            format = "install-iso";
          };
      in {
        inherit (systemArgs) format system;
        modules = [
          ./bootstrap/remote.nix

          ./hosts
          ./nixpkgs.nix
          ./modules

          inputs.home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.nix-index

          {config._module.args = {inherit systemArgs self inputs;};}
        ];
      });
    };
  };
}

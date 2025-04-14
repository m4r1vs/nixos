{systemArgs, ...}: let
  domain = "kubenix-falkenberg.niveri.dev";
  ipv4 = "91.99.10.215";
  ipv4gateway = "172.31.1.1";
  ipv6 = "2a01:4f8:c013:e704::1";
  ipv6gateway = "fe80::1";
in {
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
  ];

  services = {
    comin = {
      enable = false;
      allowForcePushMain = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/m4r1vs/NixConfig.git";
          branches.main.name = "main";
        }
      ];
    };
  };

  configured.server = {
    enable = true;
    networking = {
      enable = true;
      inherit ipv4 ipv6 ipv4gateway ipv6gateway;
      interface = "enp1s0";
      nameservers = [
        "8.8.8.8"
      ];
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [22];
    };
  };

  system = {
    nixos.label = systemArgs.hostname + ".niveri.de";
  };
}

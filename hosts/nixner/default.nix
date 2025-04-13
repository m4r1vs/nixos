{
  systemArgs,
  lib,
  ...
}: {
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
    ./www
  ];

  services = {
    configured = {
      nginx = {
        enable = true;
        inherit domain;
      };
      slidecontrol = {
        enable = true;
        inherit domain;
      };
    };
  };

  configured.server = {
    networking = {
      enable = true;
      ipv4 = "95.217.16.168";
      ipv4gateway = "172.31.1.1";
      ipv6 = "2a01:4f9:c013:785::1";
      ipv6gateway = "fe80::1";
      interface = "enp1s0";
      nameservers = [
        "8.8.8.8"
      ];
    };
    enable = true;
    services = {
      hello-nginx.enable = true;
      acme = {
        enable = true;
        domain = "niveri.dev";
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [22 53 80 443];
      allowedUDPPorts = [53];
    };
  };

  system = {
    nixos.label = systemArgs.hostname + ".niveri.de";
  };
}

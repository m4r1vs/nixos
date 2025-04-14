{systemArgs, ...}: let
  domain = "niveri.dev";
  ipv4 = "95.217.16.168";
  ipv4gateway = "172.31.1.1";
  ipv6 = "2a01:4f9:c013:785::1";
  ipv6gateway = "fe80::1";
in {
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
    comin = {
      enable = true;
      debug = true;
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
    security = {
      acme = {
        enable = true;
        inherit domain;
        useDNS01 = true;
      };
    };
    services = {
      bind = {
        enable = true;
        inherit domain;
        dnsSettings = ''
          $ORIGIN ${domain}.
          $TTL    1h
          @                     IN      SOA     ns1 dns-admin (
                                                    10  ; Serial
                                                    3h  ; Refresh
                                                    1h  ; Retry
                                                    1w  ; Expire
                                                    1h) ; Negative Cache TTL
                                IN      NS      ns1
                                IN      NS      ns2

          falkenberg.kubenix    IN      A       91.99.10.215
                                IN      AAAA    2a01:4f8:c013:e704::1

          @                     IN      A       ${ipv4}
                                IN      AAAA    ${ipv6}

          *                     IN      A       ${ipv4}
                                IN      AAAA    ${ipv6}
        '';
      };
      cache = {
        inherit domain;
        enable = true;
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

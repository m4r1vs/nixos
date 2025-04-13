{
  systemArgs,
  lib,
  ...
}: {
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
  ];

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

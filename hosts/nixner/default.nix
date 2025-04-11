{
  lib,
  systemArgs,
  ...
}: {
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
  ];

  networking = {
    firewall = {
      enable = lib.mkForce false;
      # allowedTCPPorts = [22];
    };
  };

  services = {
    # fail2ban.enable = true;
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  system = {
    nixos.label = systemArgs.hostname + ".niveri.de";
  };
}

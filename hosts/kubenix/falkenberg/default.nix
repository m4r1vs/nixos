{
  systemArgs,
  config,
  ...
}: let
  inherit (systemArgs) ipv4;
  k8sPort = 6443;
in {
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
  ];

  configured.server = {
    enable = true;
    networking = {
      enable = true;
      nameservers = [
        "8.8.8.8"
      ];
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [53 80 443 6443];
      allowedUDPPorts = [53];
    };
  };

  services.kubernetes = {
    roles = ["master" "node"];
    apiserverAddress = "https://${config.networking.fqdn}:${toString k8sPort}";
    masterAddress = config.networking.fqdn;
    easyCerts = true;
    addons.dns = {
      enable = true;
      clusterDomain = "kubenix.local";
      coredns = {
        imageName = "coredns/coredns";
        imageDigest = "sha256:4779e7517f375a597f100524db6f7f8b5b8499a6ccd14aacfa65432d4cfd5789";
        finalImageTag = "arm64-1.12.1";
        sha256 = "sha256-z3TUo76w7CyYyf5Z6lVHw/F9nZQ501CZ9NNVFFWcX58=";
      };
    };
    flannel = {
      enable = true;
      openFirewallPorts = true;
    };
    controllerManager = {
      enable = true;
    };
    kubelet = {
      enable = true;
      hostname = config.networking.fqdn;
    };
    scheduler = {
      enable = true;
    };
    apiserver = {
      enable = true;
      securePort = k8sPort;
      advertiseAddress = ipv4;
      allowPrivileged = true;
    };
  };
}

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
        imageName = "mariusniveri/my-coredns";
        imageDigest = "sha256:dd3d70eaa614e7228af8124ef37c7d8ccd92e9dd0cbdd823f727428d7b8191f3";
        finalImageTag = "latest";
        sha256 = "sha256-ID+qV6/knQDQ8leyq4r08uexPdDiu739Qeh/cBP0GfE=";
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

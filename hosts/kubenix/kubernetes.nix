{
  systemArgs,
  lib,
  ...
}: let
  inherit (systemArgs) clusterRoles k8sPort masterFqdn masterIpv4 domain;
in {
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
    inherit domain;
    firewall = {
      allowedTCPPorts = [53 80 443 6443];
      allowedUDPPorts = [53];
      trustedInterfaces = [
        "enp7s0"
      ];
    };
    extraHosts = ''
      ${masterIpv4} ${masterFqdn}
      10.0.0.4 ronhof.kubenix.local
      10.0.0.3 stadeln.kubenix.local
    '';
  };

  services.comin = {
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

  services.kubernetes = let
    masterAddr = "https://${masterFqdn}:${toString k8sPort}";
    isMaster = builtins.elem "master" clusterRoles;
  in {
    roles = clusterRoles;
    apiserverAddress = masterAddr;
    masterAddress = masterFqdn;
    easyCerts = true;
    addons.dns = {
      enable = true;
      clusterDomain = domain;
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
    proxy.enable = true;
    kubelet =
      if isMaster
      then {
        enable = true;
        hostname = masterFqdn;
      }
      else {
        enable = true;
        kubeconfig.server = masterAddr;
      };
    apiserver = lib.mkIf isMaster {
      enable = true;
      securePort = k8sPort;
      advertiseAddress = masterIpv4;
      allowPrivileged = true;
    };
  };
}

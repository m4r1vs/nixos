{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.configured.server.networking;
in {
  options.configured.server.networking = {
    enable = mkEnableOption "Enable custom networking (do not use DHCPCD)";
    ipv4 = mkOption {
      type = types.nullOr types.singleLineStr;
      default = null;
      description = "Static IPv4 Address to bind to interface";
    };
    ipv4gateway = mkOption {
      type = types.nullOr types.singleLineStr;
      default = null;
      description = "Static IPv4 Gateway to use on interface";
    };
    ipv6 = mkOption {
      type = types.nullOr types.singleLineStr;
      default = null;
      description = "Static IPv6 Address to bind to interface";
    };
    ipv6gateway = mkOption {
      type = types.nullOr types.singleLineStr;
      default = null;
      description = "Static IPv6 Gateway to use on interface";
    };
    nameservers = mkOption {
      type = types.nullOr (types.listOf types.singleLineStr);
      default = null;
      description = "Nameservers to use";
    };
    interface = mkOption {
      type = types.singleLineStr;
      default = "enp1s0";
      description = "network interface to use";
    };
  };
  config = mkIf cfg.enable {
    networking = {
      dhcpcd.enable = false;
      useDHCP = lib.mkDefault false;
      nameservers = mkIf (cfg.nameservers != null) cfg.nameservers;
      enableIPv6 = true;
      defaultGateway = mkIf (cfg.ipv4gateway != null) {
        address = cfg.ipv4gateway;
        interface = cfg.interface;
      };
      defaultGateway6 = mkIf (cfg.ipv6gateway != null) {
        address = cfg.ipv6gateway;
        interface = cfg.interface;
      };
      interfaces = {
        "${cfg.interface}" = mkIf (cfg.ipv4 != null || cfg.ipv6 != null || cfg.ipv4gateway != null || cfg.ipv6gateway != null) {
          ipv4.addresses = mkIf (cfg.ipv4 != null) [
            {
              address = cfg.ipv4;
              prefixLength = 20;
            }
          ];
          ipv4.routes = mkIf (cfg.ipv4gateway != null) [
            {
              address = cfg.ipv4gateway;
              prefixLength = 32;
            }
          ];
          ipv6.addresses = mkIf (cfg.ipv6 != null) [
            {
              address = cfg.ipv6;
              prefixLength = 64;
            }
          ];
          ipv6.routes = mkIf (cfg.ipv6gateway != null) [
            {
              address = cfg.ipv6gateway;
              prefixLength = 128;
            }
          ];
        };
      };
    };
  };
}

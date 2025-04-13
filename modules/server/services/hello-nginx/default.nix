{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.configured.server.services.hello-nginx;
in {
  options.configured.server.services.hello-nginx = {
    enable = mkEnableOption "Serve a static Hello-World HTML page using NGINX";
    domain = mkOption {
      type = types.singleLineStr;
      default = "niveri.dev";
      description = "The domain to use for the virtual hosts";
    };
  };
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/${cfg.domain}/cert.pem";
        sslCertificateKey = "/var/lib/acme/${cfg.domain}/key.pem";
        globalRedirect = "marius.${cfg.domain}";
      };

      virtualHosts."nixner.${cfg.domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/${cfg.domain}/cert.pem";
        sslCertificateKey = "/var/lib/acme/${cfg.domain}/key.pem";
        globalRedirect = "github.com/m4r1vs/NixConfig";
      };

      virtualHosts."marius.${cfg.domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/${cfg.domain}/cert.pem";
        sslCertificateKey = "/var/lib/acme/${cfg.domain}/key.pem";
        locations."/" = {
          root = ./root;
          index = "index.html";
          extraConfig = ''
            default_type text/html;
            limit_except GET HEAD {
              deny all;
            }
          '';
        };
      };
    };
  };
}

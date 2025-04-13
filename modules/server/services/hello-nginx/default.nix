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
    services.slidecontrol-server = {
      enable = true;
      port = 1337;
      dataDir = "/var/data/slidecontrol";
    };

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

      virtualHosts."slides.${cfg.domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/${cfg.domain}/cert.pem";
        sslCertificateKey = "/var/lib/acme/${cfg.domain}/key.pem";
        locations."/" = {
          root = "${pkgs.slidecontrol-pwa}/dist";
          index = "index.html";
          extraConfig = ''
            default_type text/html;
            error_page 404 =200 /index.html;
            limit_except GET HEAD {
              deny all;
            }
          '';
        };
      };

      virtualHosts."sc-server.${cfg.domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/${cfg.domain}/cert.pem";
        sslCertificateKey = "/var/lib/acme/${cfg.domain}/key.pem";

        locations."/" = {
          proxyPass = "http://0.0.0.0:1337";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_http_version 1.1;
            proxy_headers_hash_bucket_size 128;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
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

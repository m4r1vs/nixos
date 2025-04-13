{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.configured.server.services.acme;
in {
  options.configured.server.services.acme = {
    enable = mkEnableOption "Enable Let's Encrypt";
    email = mkOption {
      type = types.singleLineStr;
      default = "marius.niveri@gmail.com";
      description = "The Email to use for Let's Encrypt";
    };
    domain = mkOption {
      type = types.nullOr types.singleLineStr;
      default = null;
      description = "The Domain to certify (including all subdomains)";
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.domain != null;
        message = "configured.server.acme.domain must be specified!";
      }
    ];

    /*
    BIND needs to dynamically update its configuration to set the TXT record for ACME.
    So we need to provide a folder, Bind (user "named") can write to.
    */
    system.activationScripts.bind-zones.text = ''
      mkdir -p /etc/bind/zones
      chown named:named /etc/bind/zones
    '';

    environment.etc."bind/zones/${cfg.domain}.zone" = {
      enable = true;
      user = "named";
      group = "named";
      mode = "0644";
      text = ''
        $ORIGIN ${cfg.domain}.
        $TTL    1h
        @               IN      SOA     ns1 dns-admin (
                                            10  ; Serial
                                            3h  ; Refresh
                                            1h  ; Retry
                                            1w  ; Expire
                                            1h) ; Negative Cache TTL
                        IN      NS      ns1
                        IN      NS      ns2

        @               IN      A       95.217.16.168
                        IN      AAAA    2a01:4f9:c013:785::1

        *               IN      A       95.217.16.168
                        IN      AAAA    2a01:4f9:c013:785::1
      '';
    };

    /*
    In order to create a Wildcard certificate (*.example.com),
    we need to use DNS certification (DNS-01 challange to be precise).
    We could simply use an existing provider such as Namecheap.
      However where is the fun in that?
    We use Berkley Internet Name Domain (BIND) to host our own DNS.
    The ACME service will tell BIND to create a TXT entry with a public key
    that allows it to verify the authenticity of the given domain.
    The certificate and key is then placed in /var/lib/acme/DOMAIN/ for
    HTTP servers to read.
    */
    services.bind = {
      enable = true;
      extraConfig = ''
        include "/var/lib/secrets/dnskeys.conf";
      '';
      zones = [
        {
          name = "${cfg.domain}";
          file = "/etc/bind/zones/${cfg.domain}.zone";
          master = true;
          extraConfig = "allow-update { key rfc2136key.${cfg.domain}.; };";
        }
      ];
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;
      certs."${cfg.domain}" = {
        group = "nginx";
        dnsProvider = "rfc2136";
        domain = "*.${cfg.domain}";
        extraDomainNames = [cfg.domain];
        environmentFile = "/var/lib/secrets/certs.secret";
        dnsPropagationCheck = false;
      };
    };

    /*
    Dynamically create the keys so that we don't have to figure out how to handle secrets.
    */
    systemd.services.dns-rfc2136-conf = {
      requiredBy = ["acme-${cfg.domain}.service" "bind.service"];
      before = ["acme-${cfg.domain}.service" "bind.service"];
      unitConfig = {
        ConditionPathExists = "!/var/lib/secrets/dnskeys.conf";
      };
      serviceConfig = {
        Type = "oneshot";
        UMask = 0077;
      };
      path = [pkgs.bind];
      script = ''
        mkdir -p /var/lib/secrets
        chmod 755 /var/lib/secrets
        tsig-keygen rfc2136key.${cfg.domain} > /var/lib/secrets/dnskeys.conf
        chown named:root /var/lib/secrets/dnskeys.conf
        chmod 400 /var/lib/secrets/dnskeys.conf

        # extract secret value from the dnskeys.conf
        while read x y; do if [ "$x" = "secret" ]; then secret="''${y:1:''${#y}-3}"; fi; done < /var/lib/secrets/dnskeys.conf

        cat > /var/lib/secrets/certs.secret << EOF
        RFC2136_NAMESERVER='127.0.0.1:53'
        RFC2136_TSIG_ALGORITHM='hmac-sha256.'
        RFC2136_TSIG_KEY='rfc2136key.${cfg.domain}'
        RFC2136_TSIG_SECRET='$secret'
        EOF
        chmod 400 /var/lib/secrets/certs.secret
      '';
    };

    /**/
  };
}

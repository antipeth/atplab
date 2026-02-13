{
  config,
  lib,
  ...
}: let
  cfg = config.services.matrix-conduit;
in
  lib.mkIf false {
    services = {
      matrix-conduit = {
        enable = true;
        settings = {
          global = {
            address = "127.0.0.1";
            port = 6761;
            server_name = "0pt.dpdns.org";
            database_backend = "sqlite";
            allow_federation = false;
            allow_registration = false;
            well_known = {
              client = "https://conduit.${cfg.settings.global.server_name}";
              server = "conduit.${cfg.settings.global.server_name}:443";
            };
          };
        };
      };
      nginx.virtualHosts = {
        "0pt.dpdns.org" = {
          forceSSL = true;
          kTLS = true;
          sslCertificate = "/etc/nginx/self-sign.crt";
          sslCertificateKey = "/etc/nginx/self-sign.key";
          extraConfig = ''
            proxy_hide_header X-Powered-By;
            proxy_hide_header Server;
          '';
          locations."/.well-known/matrix/" = {
            proxyPass = "http://${cfg.settings.global.address}:${toString cfg.settings.global.port}/.well-known/matrix/";
            recommendedProxySettings = true;
            extraConfig = ''
              proxy_buffering off;
              client_max_body_size 20000m;
            '';
          };
        };
        "conduit.0pt.dpdns.org" = {
          forceSSL = true;
          kTLS = true;
          sslCertificate = "/etc/nginx/self-sign.crt";
          sslCertificateKey = "/etc/nginx/self-sign.key";
          extraConfig = ''
            proxy_hide_header X-Powered-By;
            proxy_hide_header Server;
          '';
          locations."/" = {
            proxyPass = "http://${cfg.settings.global.address}:${toString cfg.settings.global.port}";
            recommendedProxySettings = true;
            extraConfig = ''
              proxy_buffering off;
              client_max_body_size 20000m;
            '';
          };
        };
      };
    };
  }

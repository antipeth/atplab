{
  config,
  lib,
  ...
}: let
  cfg = config.services.grafana;
in
  with lib; {
    services = {
      grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 3000;
            enforce_domain = true;
            enable_gzip = true;
            domain = "grafana.0pt.lab";
          };
          database = {
            type = "postgres";
            host = "/run/postgresql";
            name = "grafana";
            user = "grafana";
          };
        };
      };
      nginx.virtualHosts."${toString cfg.settings.server.domain}" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://${toString cfg.settings.server.http_addr}:${toString cfg.settings.server.http_port}";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
      postgresql = mkIf (cfg.settings.database.type == "postgres") {
        enable = true;

        ensureDatabases = singleton cfg.database.name;
        ensureUsers = singleton {
          name = cfg.settings.database.user;
          ensureDBOwnership = true;
        };
        authentication = ''
          host ${cfg.settings.database.name} ${cfg.settings.database.user} 127.0.0.1/32 trust
        '';
      };
    };
  }

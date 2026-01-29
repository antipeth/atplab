{config, ...}: let
  cfg = config.services.readeck;
in {
  sops.secrets.octopus-readeck-env = {
    mode = "0400";
    owner = "readeck";
    group = "readeck";
    format = "binary";
    sopsFile = ../secrets/readeck-env;
  };
  services = {
    readeck = {
      enable = true;
      environmentFile = config.sops.secrets.octopus-readeck-env.path;
      settings = {
        main = {
          log_level = "INFO";
          data_directory = "data";
        };
        server = {
          host = "127.0.0.1";
          port = 8003;
          base_url = "https://readeck.0pt.dpdns.org";
        };
        database.source = "sqlite3:data/db.sqlite3";
      };
    };
    nginx.virtualHosts."readeck.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.readeck.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
    anubis.instances.readeck.settings = {
      TARGET = "http://${cfg.settings.server.host}:${toString cfg.settings.server.port}";
      BIND = "/run/anubis/anubis-readeck/anubis-readeck.sock";
      METRICS_BIND = "/run/anubis/anubis-readeck/anubis-readeck-metrics.sock";
    };
  };
  users.users.readeck = {
    name = "readeck";
    group = "readeck";
    isSystemUser = true;
  };
  users.groups.readeck = {};
}

{config, ...}: let
  cfg = config.services.umami;
in {
  sops.secrets.octopus-umami-secret = {
    mode = "0400";
    owner = "umami";
    group = "umami";
    format = "binary";
    sopsFile = ../secrets/umami-secret;
  };
  services = {
    umami = {
      enable = true;
      createPostgresqlDatabase = true;
      settings = {
        APP_SECRET_FILE = config.sops.secrets.octopus-umami-secret.path;
        COLLECT_API_ENDPOINT = "/appui";
        TRACKER_SCRIPT_NAME = ["login.js"];
        HOSTNAME = "127.0.0.1";
        PORT = 3002;
        DISABLE_TELEMETRY = true;
        REDIS_URL = "redis://${config.services.dragonflydb.bind}:${toString config.services.dragonflydb.port}";
      };
    };
    nginx.virtualHosts."umami.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.umami.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
    anubis.instances.umami.settings = {
      TARGET = "http://${cfg.settings.HOSTNAME}:${toString cfg.settings.PORT}";
      BIND = "/run/anubis/anubis-umami/anubis-umami.sock";
      METRICS_BIND = "/run/anubis/anubis-umami/anubis-umami-metrics.sock";
    };
  };
  users.users.umami = {
    name = "umami";
    group = "umami";
    isSystemUser = true;
  };
  users.groups.umami = {};
}

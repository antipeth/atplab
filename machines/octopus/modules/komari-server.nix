{config, ...}: let
  cfg = config.services.komari-server;
in {
  sops.secrets.octopus-komari-server-env = {
    mode = "0440";
    owner = cfg.user;
    group = cfg.group;
    format = "binary";
    sopsFile = ../secrets/komari-server-env;
  };
  services = {
    komari-server = {
      enable = true;
      host = "127.0.0.1";
      port = "25774";
      environmentFile = config.sops.secrets.octopus-komari-server-env.path;
    };
    gatus.settings.endpoints = [
      {
        name = "komari-server";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.host}:${cfg.port}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts."eye.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.komari-server.settings.BIND}:";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.komari-server.settings = {
      TARGET = "http://${cfg.host}:${cfg.port}";
      BIND = "/run/anubis/anubis-komari-server/anubis-komari-server.sock";
      METRICS_BIND = "/run/anubis/anubis-komari-server/anubis-komari-server-metrics.sock";
    };
  };
}

{config, ...}: let
  cfg = config.services.grafana;
in {
  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          enforce_domain = true;
          enable_gzip = true;
          domain = "grafana.0pt.dpdns.org";
        };
      };
    };
    gatus.settings.endpoints = [
      {
        name = "grafana";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.settings.server.http_addr}:${toString cfg.settings.server.http_port}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts."${cfg.settings.server.domain}" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.grafana.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.grafana.settings = {
      TARGET = "http://${cfg.settings.server.http_addr}:${toString cfg.settings.server.http_port}";
      BIND = "/run/anubis/anubis-grafana/anubis-grafana.sock";
      METRICS_BIND = "/run/anubis/anubis-grafana/anubis-grafana-metrics.sock";
    };
  };
}

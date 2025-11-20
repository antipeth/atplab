{config, ...}: let
  cfg = config.services.searx;
in {
  sops.secrets.octopus-searxng-env = {
    mode = "0400";
    owner = "searx";
    group = "searx";
    format = "binary";
    sopsFile = ../secrets/searxng-env;
  };
  services = {
    searx = {
      enable = true;
      settings.server = {
        base_url = "https://search.0pt.dpdns.org";
        bind_address = "127.0.0.1";
        port = 8081;
      };
      environmentFile = config.sops.secrets.octopus-searxng-env.path;
    };
    gatus.settings.endpoints = [
      {
        name = "searxng";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.settings.server.bind_address}:${toString cfg.settings.server.port}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts."search.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.search.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.search.settings = {
      TARGET = "http://${cfg.settings.server.bind_address}:${toString cfg.settings.server.port}";
      BIND = "/run/anubis/anubis-search/anubis-search.sock";
      METRICS_BIND = "/run/anubis/anubis-search/anubis-search-metrics.sock";
    };
  };
}

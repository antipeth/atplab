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
        proxyPass = "http://unix:${toString config.services.anubis.instances.grafana.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.grafana.settings.TARGET = "http://${toString cfg.settings.server.http_addr}:${toString cfg.settings.server.http_port}";
  };
}

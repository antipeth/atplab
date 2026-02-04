{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.cockpit;
in {
  services = {
    cockpit = {
      enable = true;
      port = 9090;
      plugins = [pkgs.cockpit-zfs];
      allowed-origins = ["https://cockpit.0pt.dpdns.org"];
      settings = {
        WebService = {
          ProtocolHeader = "X-Forwarded-Proto";
          ForwardedForHeader = "X-Forwarded-For";
          LoginTitle = "Cockpit";
        };
      };
    };
    nginx.virtualHosts."cockpit.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.cockpit.settings.BIND}:";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.cockpit.settings = {
      TARGET = "http://127.0.0.1:${toString cfg.port}";
      BIND = "/run/anubis/anubis-cockpit/anubis-cockpit.sock";
      METRICS_BIND = "/run/anubis/anubis-cockpit/anubis-cockpit-metrics.sock";
    };
  };
}

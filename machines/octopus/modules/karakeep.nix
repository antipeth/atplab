{config, ...}: let
  cfg = config.services.karakeep;
in {
  services = {
    karakeep = {
      enable = true;
      browser.enable = false;
      extraEnvironment = {
        WORKERS_HOST = "127.0.0.1";
        PORT = "3003";
        DISABLE_SIGNUPS = "true";
        DISABLE_NEW_RELEASE_CHECK = "true";
      };
    };
    nginx.virtualHosts."karakeep.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.karakeep.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
    anubis.instances.karakeep.settings = {
      TARGET = "http://${cfg.extraEnvironment.WORKERS_HOST}:${cfg.extraEnvironment.PORT}";
      BIND = "/run/anubis/anubis-karakeep/anubis-karakeep.sock";
      METRICS_BIND = "/run/anubis/anubis-karakeep/anubis-karakeep-metrics.sock";
    };
  };
}

{config, ...}: let
  cfg = config.services.gatus;
in {
  services = {
    gatus = {
      enable = true;
      settings = {
        web = {
          address = "127.0.0.1";
          port = 8083;
        };
        ui = {
          title = "Gatus";
          dashboard-heading = "Health Dashboard";
          dashboard-subheading = "Monitoring the 🧊, day after day...";
          header = "ATP's 🧊 lab";
          default-sort-by = "group";
        };
        alerting.gotify = {
          server-url = "http://${config.services.gotify.environment.GOTIFY_SERVER_LISTENADDR}:${toString config.services.gotify.environment.GOTIFY_SERVER_PORT}";
          token = import ../values/gotify-gatus-token.nix;
          priority = 0;
          default-alert = {
            description = "health check failed";
            send-on-resolved = true;
            failure-threshold = 2;
          };
        };
      };
    };
    nginx.virtualHosts."gatus.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.gatus.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.gatus.settings.TARGET = "http://${cfg.settings.web.address}:${toString cfg.settings.web.port}";
  };
}

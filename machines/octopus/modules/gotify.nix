{config, ...}: let
  cfg = config.services.gotify;
in {
  services = {
    gotify = {
      enable = true;
      environment = {
        GOTIFY_SERVER_PORT = 1245;
        GOTIFY_SERVER_LISTENADDR = "127.0.0.1";
        GOTIFY_DATABASE_DIALECT = "sqlite3";
        GOTIFY_REGISTRATION = "false";
      };
    };
    nginx.virtualHosts."gotify.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${toString cfg.environment.GOTIFY_SERVER_LISTENADDR}:${toString cfg.environment.GOTIFY_SERVER_PORT}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

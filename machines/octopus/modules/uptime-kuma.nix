{config, ...}: let
  cfg = config.services.uptime-kuma;
in {
  services = {
    uptime-kuma = {
      enable = true;
      settings = {
        HOST = "127.0.0.1";
        PORT = "4000";
        # To fix the Node.js issue when initializing the database
        HOME = "/var/lib/uptime-kuma";
      };
    };
    nginx.virtualHosts."uptime.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${toString cfg.settings.HOST}:${toString cfg.settings.PORT}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

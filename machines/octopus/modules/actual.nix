{config, ...}: let
  cfg = config.services.actual;
in {
  services = {
    actual = {
      enable = true;
      settings = {
        hostname = "127.0.0.1";
        port = 13000;
        allowedLoginMethods = ["password"];
      };
    };
    nginx.virtualHosts."actual.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${toString config.services.anubis.instances.actual.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.actual.settings.TARGET = "http://${toString cfg.settings.hostname}:${toString cfg.settings.port}";
  };
}

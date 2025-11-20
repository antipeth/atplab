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
    gatus.settings.endpoints = [
      {
        name = "actual";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.settings.hostname}:${toString cfg.settings.port}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
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
        proxyPass = "http://unix:${config.services.anubis.instances.actual.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.actual.settings.TARGET = "http://${cfg.settings.hostname}:${toString cfg.settings.port}";
  };
}

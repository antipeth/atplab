{config, ...}: let
  cfg = config.services.microbin;
in {
  sops.secrets.octopus-microbin-env = {
    mode = "0400";
    owner = "nobody";
    group = "nogroup";
    format = "binary";
    sopsFile = ../secrets/microbin-env;
  };
  services = {
    microbin = {
      enable = true;
      passwordFile = config.sops.secrets.octopus-microbin-env.path;
      settings = {
        MICROBIN_BIND = "127.0.0.1";
        MICROBIN_PORT = 8082;
        MICROBIN_HASH_IDS = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
    gatus.settings.endpoints = [
      {
        name = "microbin";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.settings.MICROBIN_BIND}:${toString cfg.settings.MICROBIN_PORT}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts."microbin.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.microbin.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.microbin.settings.TARGET = "http://${cfg.settings.MICROBIN_BIND}:${toString cfg.settings.MICROBIN_PORT}";
  };
}

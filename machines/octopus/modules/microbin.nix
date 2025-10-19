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
        proxyPass = "http://${toString cfg.settings.MICROBIN_BIND}:${toString cfg.settings.MICROBIN_PORT}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

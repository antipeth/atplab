{config, ...}: let
  cfg = config.services.paperless;
in {
  services = {
    paperless = {
      enable = true;
      domain = "paperless.0pt.lab";
    };
    nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.address}:${toString cfg.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

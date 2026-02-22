{config, ...}: let
  cfg = config.services.zeroclaw;
in {
  services = {
    zeroclaw = {
      enable = true;
      host = "127.0.0.1";
      port = "3000";
    };
    nginx.virtualHosts."zeroclaw.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.host}:${cfg.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

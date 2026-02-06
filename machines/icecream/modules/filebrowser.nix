{config, ...}: let
  cfg = config.services.filebrowser;
in {
  services = {
    filebrowser = {
      enable = true;
      settings = {
        address = "127.0.0.1";
        port = 8081;
      };
    };
    nginx.virtualHosts."filebrowser.0pt.lab" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.settings.address}:${toString cfg.settings.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

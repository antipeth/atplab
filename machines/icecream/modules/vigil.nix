{config, ...}: let
  cfg = config.services.vigil-server;
in {
  services = {
    vigil-server = {
      enable = true;
      port = 9080;
      # environmentFile = /tmp/vigil;
      auth.enable = true;
    };
    vigil-agent = {
      enable = true;
      user = "root";
      group = "root";
    };
    nginx.virtualHosts."vigil.0pt.lab" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

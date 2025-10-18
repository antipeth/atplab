{config, ...}: let
  cfg = config.services.headscale;
in {
  services = {
    headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8080;
      settings = {
        dns = {
          nameservers.global = [
            "127.0.0.1"
            "::1"
          ];
          magic_dns = true;
          base_domain = import ../values/hs-md-bd.nix;
        };
        server_url = "https://hs.0pt.dpdns.org";
      };
    };
    nginx.virtualHosts."hs.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${toString cfg.address}:${toString cfg.port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

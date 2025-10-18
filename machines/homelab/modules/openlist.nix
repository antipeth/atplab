{config, ...}: let
  cfg = config.services.openlist;
in {
  sops.secrets.homelab-openlist-env = {
    mode = "0400";
    owner = cfg.user;
    group = cfg.group;
    format = "binary";
    sopsFile = ../secrets/openlist-env;
  };
  services = {
    openlist = {
      enable = true;
      environmentFile = config.sops.secrets.homelab-openlist-env.path;
    };
    nginx.virtualHosts."openlist.0pt.lab" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:5244";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

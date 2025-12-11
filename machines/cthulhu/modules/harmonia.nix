{config, ...}: let
  cfg = config.services.harmonia;
in {
  sops.secrets.cthulhu-nix-serve-key = {
    mode = "0400";
    owner = "harmonia";
    group = "harmonia";
    format = "binary";
    sopsFile = ../secrets/nix-serve-key;
  };
  services = {
    harmonia = {
      enable = false;
      settings = {
        bind = "127.0.0.1:5000";
      };
      signKeyPaths = [config.sops.secrets.cthulhu-nix-serve-key.path];
    };
    nginx.virtualHosts."cache.0pt.de5.net" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.settings.bind}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
  };
  users.users.harmonia = {
    name = "harmonia";
    group = "harmonia";
    isSystemUser = true;
  };
  users.groups.harmonia = {};
}

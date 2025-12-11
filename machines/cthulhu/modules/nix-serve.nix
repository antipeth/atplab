{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.nix-serve;
in {
  sops.secrets.cthulhu-nix-serve-key = {
    mode = "0400";
    owner = "nix-serve";
    group = "nix-serve";
    format = "binary";
    sopsFile = ../secrets/nix-serve-key;
  };
  services = {
    nix-serve = {
      enable = true;
      package = pkgs.nix-serve-ng;
      bindAddress = "127.0.0.1";
      port = 5000;
      secretKeyFile = config.sops.secrets.cthulhu-nix-serve-key.path;
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
        proxyPass = "http://${cfg.bindAddress}:${toString cfg.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
  };
  users.users.nix-serve = {
    name = "nix-serve";
    group = "nix-serve";
    isSystemUser = true;
  };
  users.groups.nix-serve = {};
}

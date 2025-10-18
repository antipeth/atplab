{config, ...}: let
  cfg = config.services.wakapi;
in {
  sops.secrets.octopus-wakapi-passwd-salt = {
    mode = "0400";
    owner = "wakapi";
    group = "wakapi";
    format = "binary";
    sopsFile = ../secrets/wakapi-passwd-salt;
  };
  services = {
    wakapi = {
      enable = true;
      # see https://github.com/NixOS/nixpkgs/blob/88a55dffa4d44d294c74c298daf75824dc0aafb5/nixos/modules/services/web-apps/wakapi.nix#L155
      # the passwordSaltFile would need environment file like
      # ''
      # WAKAPI_PASSWORD_SALT=xxxxxxxxxxxxxxxxxxxxx
      # ''
      passwordSaltFile = config.sops.secrets.octopus-wakapi-passwd-salt.path;
      settings = {
        env = "production";
        server = {
          listen_ipv4 = "127.0.0.1";
          listen_ipv6 = "-";
          port = 3001;
          base_path = "/";
          public_url = "https://wakapi.0pt.dpdns.org";
        };
        security = {
          allow_signup = false;
          invite_codes = false;
        };
      };
    };
    nginx.virtualHosts."wakapi.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${toString cfg.settings.server.listen_ipv4}:${toString cfg.settings.server.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}

{config, ...}: let
  cfg = config.services.komari-server;
in {
  sops.secrets.octopus-komari-server-env = {
    mode = "0440";
    owner = cfg.user;
    group = cfg.group;
    format = "binary";
    sopsFile = ../secrets/komari-server-env;
  };
  services = {
    komari-server = {
      enable = true;
      host = "127.0.0.1";
      port = "25774";
      environmentFile = config.sops.secrets.octopus-komari-server-env.path;
    };
    nginx = {
      virtualHosts = {
        "eye.0pt.dpdns.org" = {
          forceSSL = true;
          kTLS = true;
          sslCertificate = "/etc/nginx/self-sign.crt";
          sslCertificateKey = "/etc/nginx/self-sign.key";
          extraConfig = ''
            proxy_hide_header X-Powered-By;
            proxy_hide_header Server;
          '';
          locations = {
            "/" = {
              proxyPass = "http://${toString cfg.host}:${toString cfg.port}";
              recommendedProxySettings = true;
              proxyWebsockets = true;
              extraConfig = ''
                proxy_buffering off;
              '';
            };
          };
        };
      };
    };
  };
}

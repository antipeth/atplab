{
  config,
  lib,
  ...
}: let
  cfg = config.services.immich;
in
  lib.mkIf true {
    hardware.graphics.enable = true;
    users.users.immich.extraGroups = ["video" "render"];
    services = {
      immich = {
        enable = true;
        host = "127.0.0.1";
        accelerationDevices = ["/dev/dri/renderD128"];
      };
      nginx.virtualHosts."immich.0pt.lab" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
            proxy_buffering off;
          '';
        };
      };
    };
  }

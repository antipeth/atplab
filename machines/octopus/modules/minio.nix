{config, ...}: let
  cfg = config.services.minio;
in {
  sops.secrets.octopus-minio-env = {
    mode = "0400";
    owner = "minio";
    group = "minio";
    format = "binary";
    sopsFile = ../secrets/minio-env;
  };
  services = {
    minio = {
      enable = true;
      region = "us-west-2";
      listenAddress = "127.0.0.1:19000";
      consoleAddress = "127.0.0.1:19001";
      rootCredentialsFile = config.sops.secrets.octopus-minio-env.path;
    };
    gatus.settings.endpoints = [
      {
        name = "minio";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.listenAddress}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
      {
        name = "minio-ui";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.consoleAddress}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts = {
      "minio.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://unix:${config.services.anubis.instances.minio.settings.BIND}:";
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            chunked_transfer_encoding off;
            proxy_buffering off;
            proxy_request_buffering off;
          '';
        };
      };
      "minio-ui.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        locations."/" = {
          proxyPass = "http://unix:${config.services.anubis.instances.minio-ui.settings.BIND}:";
          recommendedProxySettings = true;
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 500M;
            real_ip_header X-Real-IP;
            chunked_transfer_encoding off;
            proxy_buffering off;
            proxy_request_buffering off;
          '';
        };
      };
    };
    anubis.instances = {
      minio.settings = {
        TARGET = "http://${cfg.listenAddress}";
        BIND = "/run/anubis/anubis-minio/anubis-minio.sock";
        METRICS_BIND = "/run/anubis/anubis-minio/anubis-minio-metrics.sock";
      };
      minio-ui.settings = {
        TARGET = "http://${cfg.consoleAddress}";
        BIND = "/run/anubis/anubis-minio-ui/anubis-minio-ui.sock";
        METRICS_BIND = "/run/anubis/anubis-minio-ui/anubis-minio-ui-metrics.sock";
      };
    };
  };
}

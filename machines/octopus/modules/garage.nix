{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.garage;
  cfgw = config.services.garage-webui;
in {
  sops.secrets.octopus-garage-webui-env = {
    mode = "0400";
    owner = cfgw.user;
    group = cfgw.group;
    format = "binary";
    sopsFile = ../secrets/garage-webui-env;
  };
  services = {
    garage = {
      enable = true;
      package = pkgs.garage_2;
      settings = {
        db_engine = "lmdb";
        consistency_mode = "consistent";
        replication_factor = 1;
        compression_level = 2;
        rpc_secret = import ../values/garage-rpc-secret.nix;
        rpc_bind_addr = "127.0.0.1:3901";
        rpc_public_addr = "127.0.0.1:3901";
        s3_api = {
          api_bind_addr = "127.0.0.1:3900";
          s3_region = "us-west-2";
          root_domain = ".garage.0pt.lab";
        };
        s3_web = {
          bind_addr = "127.0.0.1:3902";
          root_domain = ".garageweb.0pt.lab";
          index = "index.html";
        };
        admin = {
          api_bind_addr = "127.0.0.1:3903";
          admin_token = import ../values/garage-admin-token.nix;
          metrics_token = import ../values/garage-metrics-token.nix;
        };
      };
    };
    garage-webui = {
      enable = true;
      port = 3909;
      apiBaseUrl = "http://${cfg.settings.admin.api_bind_addr}";
      s3EndpointUrl = "http://${cfg.settings.s3_api.api_bind_addr}";
      environmentFile = config.sops.secrets.octopus-garage-webui-env.path;
    };
    nginx.virtualHosts = {
      "garage.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://unix:${config.services.anubis.instances.garage.settings.BIND}:";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
      "garage-ui.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://unix:${config.services.anubis.instances.garage-ui.settings.BIND}:";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };
    anubis.instances.garage.settings.TARGET = "http://${cfg.settings.s3_api.api_bind_addr}";
    anubis.instances.garage-ui.settings.TARGET = "http://127.0.0.1:${toString cfgw.port}";
  };
}

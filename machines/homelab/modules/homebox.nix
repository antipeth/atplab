{config, ...}: let
  cfg = config.services.homebox;
in {
  services = {
    homebox = {
      enable = true;
      database.createLocally = true;
      settings = {
        HBOX_MODE = "production";
        HBOX_WEB_HOST = "127.0.0.1";
        HBOX_WEB_PORT = "7745";
        HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
        HBOX_STORAGE_CONN_STRING = "file:///var/lib/homebox/data";
      };
    };
    nginx = {
      virtualHosts = {
        "homebox.0pt.lab" = {
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
              proxyPass = "http://${toString cfg.settings.HBOX_WEB_HOST}:${toString cfg.settings.HBOX_WEB_PORT}";
              recommendedProxySettings = true;
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

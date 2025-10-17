{config, ...}: let
  cfg = config.services.glances;
in {
  services = {
    glances = {
      enable = true;
      openFirewall = true;
    };
    nginx = {
      virtualHosts = {
        "glances.0pt.lab" = {
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
              proxyPass = "http://127.0.0.1:${toString cfg.port}";
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

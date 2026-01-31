{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.kanidm;
in {
  services = {
    kanidm = {
      package = pkgs.kanidm_1_8;
      enableServer = true;
      serverSettings = {
        bindaddress = "127.0.0.1:8004";
        domain = "kanidm.0pt.dpdns.org";
        origin = "https://${cfg.serverSettings.domain}";
        tls_chain = "/etc/nginx/self-sign.crt";
        tls_key = "/etc/nginx/self-sign.key";
      };
      enableClient = true;
      clientSettings.uri = "${cfg.serverSettings.bindaddress}";
    };
    nginx.virtualHosts."${cfg.serverSettings.domain}" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "https://${cfg.serverSettings.bindaddress}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
  };
}

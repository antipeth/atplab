{config, ...}: {
  services = {
    openlist = {
      enable = true;
    };
    nginx.virtualHosts."openlist.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.openlist.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
    anubis.instances.openlist.settings = {
      TARGET = "http://127.0.0.1:5244";
      BIND = "/run/anubis/anubis-openlist/anubis-openlist.sock";
      METRICS_BIND = "/run/anubis/anubis-openlist/anubis-openlist-metrics.sock";
    };
  };
}

{config, ...}: {
  virtualisation.oci-containers.containers."myip" = {
    pull = "newer";
    image = "ghcr.io/jason5ng32/myip:latest";
    ports = [
      "127.0.0.1:18966:18966"
    ];
    labels = {
      "glance.name" = "myip";
      "glance.icon" = "sh:myip";
      "glance.description" = "The best IP Toolbox.";
    };
  };
  services = {
    nginx.virtualHosts."myip.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.myip.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.myip.settings = {
      TARGET = "http://127.0.0.1:18966";
      BIND = "/run/anubis/anubis-myip/anubis-myip.sock";
      METRICS_BIND = "/run/anubis/anubis-myip/anubis-myip-metrics.sock";
    };
  };
}

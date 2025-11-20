{config, ...}: {
  virtualisation.oci-containers.containers."convertx" = {
    pull = "newer";
    image = "ghcr.io/c4illin/convertx";
    volumes = [
      "convertx:/app/data:rw"
    ];
    ports = [
      "127.0.0.1:13001:3000"
    ];
    labels = {
      "glance.name" = "convertx";
      "glance.icon" = "sh:convertx";
      "glance.url" = "https://convertx.0pt.dpdns.org";
      "glance.description" = "Online file converter";
    };
  };
  services = {
    nginx.virtualHosts."convertx.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.convertx.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.convertx.settings = {
      TARGET = "http://127.0.0.1:13001";
      BIND = "/run/anubis/anubis-convertx/anubis-convertx.sock";
      METRICS_BIND = "/run/anubis/anubis-convertx/anubis-convertx-metrics.sock";
    };
  };
}

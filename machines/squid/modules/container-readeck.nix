{config, ...}: {
  virtualisation.oci-containers.containers."readeck" = {
    pull = "newer";
    image = "codeberg.org/readeck/readeck:latest";
    volumes = [
      "readeck:/readeck:rw"
    ];
    ports = [
      "127.0.0.1:8001:8000"
    ];
    labels = {
      "glance.name" = "readeck";
      "glance.icon" = "sh:readeck";
      "glance.url" = "https://readeck.0pt.dpdns.org";
      "glance.description" = "Bookmark";
    };
  };
  services = {
    nginx.virtualHosts."readeck.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.readeck.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.readeck.settings = {
      TARGET = "http://127.0.0.1:8001";
      BIND = "/run/anubis/anubis-readeck/anubis-readeck.sock";
      METRICS_BIND = "/run/anubis/anubis-readeck/anubis-readeck-metrics.sock";
    };
  };
}

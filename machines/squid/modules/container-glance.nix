{config, ...}: {
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.oci-containers.containers."glance" = {
    pull = "newer";
    image = "glanceapp/glance:latest";
    volumes = [
      "glance:/app/config:rw"
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
    ports = [
      "127.0.0.1:8083:8080"
    ];
    labels = {
      "glance.name" = "glance";
      "glance.icon" = "sh:glance";
      "glance.url" = "https://glance.0pt.dpdns.org";
      "glance.description" = "Dashboard";
    };
  };
  services = {
    nginx.virtualHosts."glance.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.glance.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.glance.settings = {
      TARGET = "http://127.0.0.1:8083";
      BIND = "/run/anubis/anubis-glance/anubis-glance.sock";
      METRICS_BIND = "/run/anubis/anubis-glance/anubis-glance-metrics.sock";
    };
  };
}

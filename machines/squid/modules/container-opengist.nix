{config, ...}: {
  virtualisation.oci-containers.containers."opengist" = {
    pull = "newer";
    image = "ghcr.io/thomiceli/opengist:latest";
    environment = {
      "OG_SSH_GIT_ENABLED" = "false";
      "OG_EXTERNAL_URL" = "https://opengist.0pt.dpdns.org";
    };
    ports = [
      "127.0.0.1:6157:6157"
    ];
    volumes = [
      "opengist:/opengist"
    ];
    labels = {
      "glance.name" = "opengist";
      "glance.icon" = "sh:opengist";
      "glance.url" = "https://opengist.0pt.dpdns.org";
      "glance.description" = "Open-source alternative to Github Gist";
    };
  };
  services = {
    nginx.virtualHosts."opengist.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.opengist.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.opengist.settings = {
      TARGET = "http://127.0.0.1:6157";
      BIND = "/run/anubis/anubis-opengist/anubis-opengist.sock";
      METRICS_BIND = "/run/anubis/anubis-opengist/anubis-opengist-metrics.sock";
    };
  };
}

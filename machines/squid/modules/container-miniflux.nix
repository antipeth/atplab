{config, ...}: {
  sops.secrets.squid-miniflux-env = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/miniflux-env;
  };
  virtualisation.oci-containers.containers."miniflux" = {
    pull = "newer";
    image = "ghcr.io/miniflux/miniflux:latest";
    environmentFiles = [config.sops.secrets.squid-miniflux-env.path];
    environment = {
      RUN_MIGRATIONS = "1";
      BASE_URL = "https://miniflux.0pt.dpdns.org/";
      # CREATE_ADMIN = "1";
    };
    ports = [
      "127.0.0.1:18081:8080"
    ];
    labels = {
      "glance.name" = "miniflux";
      "glance.icon" = "sh:miniflux";
      "glance.url" = "https://miniflux.0pt.dpdns.org";
      "glance.description" = "RSS Client";
    };
  };
  services = {
    nginx.virtualHosts."miniflux.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.miniflux.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.miniflux.settings.TARGET = "http://127.0.0.1:18081";
  };
}

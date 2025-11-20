{config, ...}: {
  virtualisation.oci-containers.containers."omni-tools" = {
    pull = "newer";
    image = "iib0011/omni-tools:latest";
    ports = [
      "127.0.0.1:18001:80"
    ];
    labels = {
      "glance.name" = "omni-tools";
      "glance.icon" = "sh:omnitools";
      "glance.url" = "https://omni-tools.0pt.dpdns.org";
      "glance.description" = "Web-based tools for everyday tasks";
    };
  };
  services = {
    nginx.virtualHosts."omni-tools.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      basicAuthFile = config.sops.secrets.squid-nginx-basic-auth.path;
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.omni-tools.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.omni-tools.settings = {
      TARGET = "http://127.0.0.1:18001";
      BIND = "/run/anubis/anubis-omni-tools/anubis-omni-tools.sock";
      METRICS_BIND = "/run/anubis/anubis-omni-tools/anubis-omni-tools-metrics.sock";
    };
  };
}

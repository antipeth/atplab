{config, ...}: {
  virtualisation.oci-containers.containers."chartdb" = {
    pull = "newer";
    image = "ghcr.io/chartdb/chartdb:latest";
    ports = [
      "127.0.0.1:18080:80"
    ];
    labels = {
      "glance.name" = "chartdb";
      "glance.icon" = "sh:chartdb";
      "glance.url" = "https://chartdb.0pt.dpdns.org";
      "glance.description" = "Database diagrams editor";
    };
  };
  services = {
    nginx.virtualHosts."chartdb.0pt.dpdns.org" = {
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
        proxyPass = "http://unix:${config.services.anubis.instances.chartdb.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.chartdb.settings.TARGET = "http://127.0.0.1:18080";
  };
}

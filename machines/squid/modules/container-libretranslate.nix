{config, ...}: {
  virtualisation.oci-containers.containers."libretranslate" = {
    pull = "newer";
    image = "libretranslate/libretranslate:latest";
    ports = [
      "127.0.0.1:15000:5000"
    ];
    labels = {
      "glance.name" = "libretranslate";
      "glance.icon" = "sh:libretranslate";
      "glance.url" = "https://translate.0pt.dpdns.org";
      "glance.description" = "Libre Translate";
    };
  };
  services = {
    nginx.virtualHosts."translate.0pt.dpdns.org" = {
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
        proxyPass = "http://unix:${config.services.anubis.instances.translate.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.translate.settings = {
      TARGET = "http://127.0.0.1:15000";
      BIND = "/run/anubis/anubis-translate/anubis-translate.sock";
      METRICS_BIND = "/run/anubis/anubis-translate/anubis-translate-metrics.sock";
    };
  };
}

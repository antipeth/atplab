{config, ...}: {
  virtualisation.oci-containers.containers."myspeed" = {
    pull = "newer";
    image = "germannewsmaker/myspeed:latest";
    volumes = [
      "myspeed:/myspeed/data:rw"
    ];
    ports = [
      "127.0.0.1:5216:5216"
    ];
    labels = {
      "glance.name" = "myspeed";
      "glance.icon" = "sh:myspeed";
      "glance.description" = "A speed test analysis software that shows your internet speed for up to 30 days";
    };
  };
  services = {
    nginx.virtualHosts."myspeed.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.myspeed.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.myspeed.settings = {
      TARGET = "http://127.0.0.1:5216";
      BIND = "/run/anubis/anubis-myspeed/anubis-myspeed.sock";
      METRICS_BIND = "/run/anubis/anubis-myspeed/anubis-myspeed-metrics.sock";
    };
  };
}

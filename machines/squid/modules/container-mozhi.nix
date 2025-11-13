{config, ...}: {
  virtualisation.oci-containers.containers."mozhi" = {
    pull = "newer";
    image = "codeberg.org/aryak/mozhi:latest";
    ports = [
      "127.0.0.1:13000:3000"
    ];
    labels = {
      "glance.name" = "mozhi";
      "glance.icon" = "https://codeberg.org/repo-avatars/d5972faab4a560db70bef77c018e376f531f4ae16393059e0c33396c2ef674a2";
      "glance.url" = "https://mozhi.0pt.dpdns.org";
      "glance.description" = "Translate engines Front";
    };
  };
  services = {
    nginx.virtualHosts."mozhi.0pt.dpdns.org" = {
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
        proxyPass = "http://unix:${config.services.anubis.instances.mozhi.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.mozhi.settings.TARGET = "http://127.0.0.1:13000";
  };
}

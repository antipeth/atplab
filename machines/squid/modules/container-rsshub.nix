{config, ...}: {
  virtualisation.oci-containers.containers."rsshub" = {
    pull = "newer";
    image = "ghcr.io/diygod/rsshub:latest";
    environment = {
      "PORT" = "11200";
    };
    ports = [
      "127.0.0.1:11200:11200"
    ];
  };
  services = {
    nginx.virtualHosts."rsshub.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${toString config.services.anubis.instances.rsshub.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.rsshub.settings.TARGET = "http://127.0.0.1:11200";
  };
}

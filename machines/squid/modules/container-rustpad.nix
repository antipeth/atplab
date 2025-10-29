{config, ...}: {
  virtualisation.oci-containers.containers."rustpad" = {
    pull = "newer";
    image = "ekzhang/rustpad:latest";
    environment = {
      EXPIRY_DAYS = "1";
    };
    ports = [
      "127.0.0.1:3030:3030"
    ];
    labels = {
      "glance.name" = "rustpad";
      "glance.icon" = "sh:rustpad";
      "glance.url" = "https://pad.0pt.dpdns.org";
      "glance.description" = "Online Shared Pad";
    };
  };
  services.nginx.virtualHosts."pad.0pt.dpdns.org" = {
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
      proxyPass = "http://127.0.0.1:3030";
      extraConfig = ''
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_buffering off;
      '';
    };
  };
}

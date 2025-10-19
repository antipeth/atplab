{config, ...}: {
  virtualisation.oci-containers.containers."rustpad" = {
    image = "ekzhang/rustpad:latest";
    environment = {
      EXPIRY_DAYS = "1";
    };
    ports = [
      "127.0.0.1:3030:3030"
    ];
  };
  sops.secrets.squid-rustpad-basic-auth = {
    mode = "0400";
    owner = "nginx";
    group = "nginx";
    format = "binary";
    sopsFile = ../secrets/rustpad-basic-auth;
  };
  services.nginx.virtualHosts."pad.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    basicAuthFile = config.sops.secrets.squid-rustpad-basic-auth.path;
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:3030";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}

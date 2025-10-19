{config, ...}: {
  virtualisation.oci-containers.containers."libretranslate" = {
    image = "libretranslate/libretranslate:latest";
    ports = [
      "127.0.0.1:15000:5000"
    ];
  };
  sops.secrets.squid-libretranslate-basic-auth = {
    mode = "0400";
    owner = "nginx";
    group = "nginx";
    format = "binary";
    sopsFile = ../secrets/nginx-basic-auth;
  };
  services.nginx.virtualHosts."translate.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    basicAuthFile = config.sops.secrets.squid-libretranslate-basic-auth.path;
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:15000";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}

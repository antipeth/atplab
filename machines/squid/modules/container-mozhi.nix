{config, ...}: {
  virtualisation.oci-containers.containers."mozhi" = {
    image = "codeberg.org/aryak/mozhi:latest";
    ports = [
      "127.0.0.1:13000:3000"
    ];
  };
  sops.secrets.squid-mozhi-basic-auth = {
    mode = "0400";
    owner = "nginx";
    group = "nginx";
    format = "binary";
    sopsFile = ../secrets/nginx-basic-auth;
  };
  services.nginx.virtualHosts."mozhi.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    basicAuthFile = config.sops.secrets.squid-mozhi-basic-auth.path;
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:13000";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}

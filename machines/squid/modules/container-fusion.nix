{config, ...}: {
  sops.secrets.squid-fusion-env = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/fusion-env;
  };
  virtualisation.oci-containers.containers."fusion" = {
    image = "ghcr.io/0x2e/fusion:latest";
    environmentFiles = [config.sops.secrets.squid-fusion-env.path];
    volumes = [
      "fusion:/data:rw"
    ];
    ports = [
      "127.0.0.1:8081:8080"
    ];
    labels = {
      "glance.name" = "fusion";
      "glance.icon" = "sh:fusion-rss";
      "glance.url" = "https://fusion.0pt.dpdns.org";
      "glance.description" = "RSS Client";
    };
  };
  services.nginx.virtualHosts."fusion.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:8081";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}

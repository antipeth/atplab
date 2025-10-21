_: {
  virtualisation.oci-containers.containers."goatcounter" = {
    image = "arp242/goatcounter:latest";
    volumes = [
      "goatcounter:/home/goatcounter/goatcounter-data:rw"
    ];
    ports = [
      "127.0.0.1:8082:8080"
    ];
    labels = {
      "glance.name" = "goatcounter";
      "glance.icon" = "sh:goatcounter";
      "glance.url" = "https://goatcounter.0pt.dpdns.org";
      "glance.description" = "Website Analyzer";
    };
  };
  services.nginx.virtualHosts."goatcounter.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:8082";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}

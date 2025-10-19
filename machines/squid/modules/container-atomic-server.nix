_: {
  virtualisation.oci-containers.containers."atomic-server" = {
    image = "joepmeneer/atomic-server:latest";
    environment = {
      ATOMIC_SERVER_URL = "https://atomic.0pt.dpdns.org";
      ATOMIC_PORT = "9883";
    };
    volumes = [
      "atomic-storage:/atomic-storage:rw"
    ];
    ports = [
      "127.0.0.1:9883:9883"
    ];
  };
  services.nginx.virtualHosts."atomic.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:9883";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}

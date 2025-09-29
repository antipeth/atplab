_: {
  services.nginx = {
    enable = true;
    streamConfig = import ../../../sops/eval/crystal/nginx-stream-config.nix;
    virtualHosts = {
      "backup1.lkt.icu" = {
        forceSSL = true;
        sslCertificate = "/var/lib/cf-cert/example.com.pem";
        sslCertificateKey = "/var/lib/cf-cert/example.com.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            client_max_body_size 50000M;
          '';
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      10000
    ];
  };
}

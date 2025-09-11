{config, ...}: {
  users.users.nginx.extraGroups = [
    "acme"
  ];
  sops.secrets.crystal-acme-environment = {
    mode = "0440";
    owner = config.users.users.acme.name;
    group = config.users.users.acme.group;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = import ../../../sops/eval/crystal/acme-cert-email.nix;
    certs."0pt.dpdns.org" = {
      domain = "0pt.dpdns.org";
      extraDomainNames = ["*.0pt.dpdns.org"];
      dnsProvider = import ../../../sops/eval/crystal/acme-dns-provider.nix;
      environmentFile = config.sops.secrets.crystal-acme-environment.path;
      dnsPropagationCheck = false;
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
  };
  services.nginx = {
    enable = true;
    streamConfig = import ../../../sops/eval/crystal/nginx-stream-config.nix;
    virtualHosts = {
      # "wakapi.0pt.dpdns.org" = {
      #   forceSSL = true;
      #   useACMEHost = "0pt.dpdns.org";
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:3001";
      #     recommendedProxySettings = true;
      #     # extraConfig = ''
      #     #   proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      #     # '';
      #   };
      # };
      # "hs.0pt.dpdns.org" = {
      #   forceSSL = true;
      #   useACMEHost = "0pt.dpdns.org";
      #   locations."/" = {
      #     root = "/var/www/html/reverse-proxy-test";
      #     index = "index.html";
      #   };
      # };
      # "hs.0pt.dpdns.org" = {
      #   forceSSL = true;
      #   sslCertificate = "/var/lib/cf-cert/example1.com.pem";
      #   sslCertificateKey = "/var/lib/cf-cert/example1.com.key";
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:8080";
      #     proxyWebsockets = true;
      #     recommendedProxySettings = true;
      #     extraConfig = ''
      #       proxy_buffering off;
      #       add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
      #     '';
      #   };
      # };
      "backup1.lkt.icu" = {
        forceSSL = true;
        sslCertificate = "/var/lib/cf-cert/example.com.pem";
        sslCertificateKey = "/var/lib/cf-cert/example.com.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081";
          # proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            client_max_body_size 50000M;
          '';
        };
      };
      # "garage.0pt.im" = {
      #   forceSSL = true;
      #   sslCertificate = "/var/0pt.im.pem";
      #   sslCertificateKey = "/var/0pt.im.key";
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:3900";
      #     proxyWebsockets = true;
      #     recommendedProxySettings = true;
      #     extraConfig = ''
      #       proxy_buffering off;
      #     '';
      #   };
      # };
      # "garageweb.0pt.im" = {
      #   forceSSL = true;
      #   sslCertificate = "/var/0pt.im.pem";
      #   sslCertificateKey = "/var/0pt.im.key";
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:3902";
      #     # proxyWebsockets = true;
      #     recommendedProxySettings = true;
      #     extraConfig = ''
      #       proxy_buffering off;
      #     '';
      #   };
      # };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      10000
    ];
  };
}

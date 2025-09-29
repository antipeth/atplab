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
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      10000
    ];
  };
}

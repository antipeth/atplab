{ config, ... }:
{
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
    certs."0pt.icu" = {
      domain = "0pt.icu";
      extraDomainNames = [ "*.0pt.icu" ];
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
      "headscale.0pt.im" = {
        forceSSL = true;
        sslCertificate = "/var/0pt.im.pem";
        sslCertificateKey = "/var/0pt.im.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
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

{ config, pkgs, ... }:
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
    certs."0pt.im" = {
      domain = "0pt.im";
      extraDomainNames = [ "*.0pt.im" ];
      dnsProvider = import ../../../sops/eval/crystal/acme-dns-provider.nix;
      environmentFile = config.sops.secrets.crystal-acme-environment.path;
      dnsPropagationCheck = false;
      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "headscale.0pt.im" = {
        forceSSL = true;
        useACMEHost = "0pt.im";
        extraConfig = ''
          ssl_protocols TLSv1.2 TLSv1.3;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          # proxyWebsockets = true;
          # recommendedProxySettings = true;
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            # shut down for cdn
            # proxy_set_header Host $server_name;
            proxy_redirect http:// https://;
            proxy_buffering off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
          '';
        };
      };
    };
  };
}

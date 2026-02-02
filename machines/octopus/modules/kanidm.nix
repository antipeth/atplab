{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.kanidm;
in {
  sops.secrets = {
    octopus-kanidm-admin = {
      mode = "0400";
      owner = "kanidm";
      group = "kanidm";
      format = "binary";
      sopsFile = ../secrets/kanidm-admin;
    };
    octopus-kanidm-idmadmin = {
      mode = "0400";
      owner = "kanidm";
      group = "kanidm";
      format = "binary";
      sopsFile = ../secrets/kanidm-idmadmin;
    };
  };
  services = {
    kanidm = {
      package = pkgs.kanidm_1_8.withSecretProvisioning;
      enableServer = true;
      serverSettings = {
        bindaddress = "127.0.0.1:8004";
        domain = "kanidm.0pt.dpdns.org";
        origin = "https://${cfg.serverSettings.domain}";
        tls_chain = "/etc/nginx/self-sign.crt";
        tls_key = "/etc/nginx/self-sign.key";
      };
      enableClient = true;
      clientSettings.uri = "https://${cfg.serverSettings.domain}";
      provision = {
        enable = true;
        adminPasswordFile = config.sops.secrets.octopus-kanidm-admin.path;
        idmAdminPasswordFile = config.sops.secrets.octopus-kanidm-idmadmin.path;
        persons = {
          test = {
            displayName = "My Test";
            legalName = "Test Test";
            mailAddresses = ["test@example.com"];
            # groups = ["testgp"];
          };
        };
        groups = {
          testgp = {
            members = ["test"];
          };
        };
      };
    };
    nginx.virtualHosts."${cfg.serverSettings.domain}" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "https://${cfg.serverSettings.bindaddress}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
  };
}

{config, ...}: let
  cfg = config.services.karakeep;
in {
  sops.secrets = {
    octopus-kanidm-karakeep-bs = {
      mode = "0444";
      owner = "karakeep";
      group = "karakeep";
      format = "binary";
      sopsFile = ../secrets/kanidm-karakeep-bs;
    };
    octopus-karakeep-env = {
      mode = "0400";
      owner = "karakeep";
      group = "karakeep";
      format = "binary";
      sopsFile = ../secrets/karakeep-env;
    };
  };
  services = {
    karakeep = {
      enable = true;
      browser.enable = false;
      environmentFile = config.sops.secrets.octopus-karakeep-env.path;
      extraEnvironment = {
        WORKERS_HOST = "127.0.0.1";
        PORT = "3003";
        DISABLE_SIGNUPS = "true"; # Set false to allow oidc signup
        DISABLE_NEW_RELEASE_CHECK = "true";
        NEXTAUTH_URL = "https://karakeep.0pt.dpdns.org";
        OAUTH_CLIENT_ID = "karakeep";
        OAUTH_WELLKNOWN_URL = "https://kanidm.0pt.dpdns.org/oauth2/openid/karakeep/.well-known/openid-configuration";
        OAUTH_PROVIDER_NAME = "Kanidm";
      };
    };
    nginx.virtualHosts."karakeep.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.karakeep.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
    anubis.instances.karakeep.settings = {
      TARGET = "http://${cfg.extraEnvironment.WORKERS_HOST}:${cfg.extraEnvironment.PORT}";
      BIND = "/run/anubis/anubis-karakeep/anubis-karakeep.sock";
      METRICS_BIND = "/run/anubis/anubis-karakeep/anubis-karakeep-metrics.sock";
    };
    kanidm.provision.systems.oauth2.karakeep = {
      displayName = "karakeep";
      basicSecretFile = config.sops.secrets.octopus-kanidm-karakeep-bs.path;
      originUrl = "https://karakeep.0pt.dpdns.org/api/auth/callback/custom";
      originLanding = "https://karakeep.0pt.dpdns.org";
      enableLegacyCrypto = true; # Set false to use ES256. Set true to use RS256. Nextauth use RS256
      preferShortUsername = true;
      scopeMaps = {
        testgp = [
          "openid"
          "email"
          "profile"
        ];
      };
    };
  };
  users.users.karakeep = {
    name = "karakeep";
    group = "karakeep";
    isSystemUser = true;
  };
  users.groups.karakeep = {};
}

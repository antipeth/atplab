{config, ...}: let
  cfg = config.services.miniflux;
in {
  sops.secrets.octopus-kanidm-miniflux-bs = {
    mode = "0444";
    owner = "miniflux";
    group = "miniflux";
    format = "binary";
    sopsFile = ../secrets/kanidm-miniflux-bs;
  };
  services = {
    miniflux = {
      enable = true;
      # adminCredentialsFile = /run/secret;
      config = {
        CREATE_ADMIN = false;
        LISTEN_ADDR = "127.0.0.1:8005";
        WATCHDOG = false;
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_OIDC_PROVIDER_NAME = "Kanidm";
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_CLIENT_SECRET_FILE = config.sops.secrets.octopus-kanidm-miniflux-bs.path;
        OAUTH2_REDIRECT_URL = "https://miniflux.0pt.dpdns.org/oauth2/oidc/callback";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://kanidm.0pt.dpdns.org/oauth2/openid/miniflux";
        OAUTH2_USER_CREATION = 0; # Set 1 to allow OIDC Register
      };
    };
    nginx.virtualHosts."miniflux.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.miniflux.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 20000m;
        '';
      };
    };
    anubis.instances.miniflux.settings = {
      TARGET = "http://${cfg.config.LISTEN_ADDR}";
      BIND = "/run/anubis/anubis-miniflux/anubis-miniflux.sock";
      METRICS_BIND = "/run/anubis/anubis-miniflux/anubis-miniflux-metrics.sock";
    };
    kanidm.provision.systems.oauth2.miniflux = {
      displayName = "Miniflux";
      basicSecretFile = config.sops.secrets.octopus-kanidm-miniflux-bs.path;
      originUrl = "https://miniflux.0pt.dpdns.org/oauth2/oidc/callback";
      originLanding = "https://miniflux.0pt.dpdns.org";
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
  users.users.miniflux = {
    name = "miniflux";
    group = "miniflux";
    isSystemUser = true;
  };
  users.groups.miniflux = {};
}

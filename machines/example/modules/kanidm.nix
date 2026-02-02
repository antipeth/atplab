{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.kanidm;
in {
  services = {
    kanidm = {
      package = pkgs.kanidm_1_8.withSecretProvisioning;
      enableServer = true;
      serverSettings = {
        bindaddress = "127.0.0.1:8000";
        domain = "kanidm.example.com";
        origin = "https://${cfg.serverSettings.domain}";
        # Kandim must use tls
        tls_chain = "/etc/nginx/self-sign.crt";
        tls_key = "/etc/nginx/self-sign.key";
      };
      enableClient = true;
      clientSettings.uri = "https://${cfg.serverSettings.domain}";
      provision = {
        enable = true;
        adminPasswordFile = /run/adminPasswordFile;
        idmAdminPasswordFile = /run/idmAdminPasswordFile;
        persons = {
          test = {
            displayName = "My Test";
            legalName = "Test Test";
            mailAddresses = ["test@example.com"];
          };
          test1 = {
            displayName = "My Test1";
            legalName = "Test Test1";
            mailAddresses = ["test1@example.com"];
          };
        };
        groups = {
          testgp = {
            members = ["test" "test1"];
          };
        };
        systems.oauth2 = {
          miniflux = {
            displayName = "Miniflux";
            basicSecretFile = /run/basicSecretFile;
            originUrl = "https://miniflux.example.com/oauth2/oidc/callback";
            originLanding = "https://miniflux.example.com";
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
      };
    };
    # Use miniflux as oidc example
    miniflux = {
      enable = true;
      adminCredentialsFile = /run/adminCredentialsFile;
      config = {
        CREATE_ADMIN = true;
        LISTEN_ADDR = "127.0.0.1:8005";
        WATCHDOG = false;
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_OIDC_PROVIDER_NAME = "Kanidm";
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_CLIENT_SECRET_FILE = /run/basicSecretFile;
        OAUTH2_REDIRECT_URL = "https://miniflux.example.com/oauth2/oidc/callback";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://kanidm.example.com/oauth2/openid/miniflux";
        OAUTH2_USER_CREATION = 1; # Set 1 to allow OIDC Register
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

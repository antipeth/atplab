{
  config,
  lib,
  ...
}: let
  cfg = config.services.lemmy;
in {
  systemd.services.lemmy-ui = {
    environment = {
      LEMMY_UI_HOST = lib.mkForce "127.0.0.1:${toString cfg.ui.port}";
    };
  };
  services = {
    nginx.virtualHosts."${cfg.settings.hostname}" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
    };
    pict-rs = {
      enable = true;
      port = 8083;
      address = "127.0.0.1";
    };
    lemmy = {
      enable = true;
      database.createLocally = true;
      nginx.enable = true;
      ui.port = 1234;
      settings = {
        hostname = "lemmy.0pt.dpdns.org";
        bind = "127.0.0.1";
        port = 8536;
        # Whether the site is available over TLS. Needs to be true for federation to work.
        tls_enabled = true;

        # Parameters for automatic configuration of new instance (only used at first start)
        setup = {
          # Username for the admin user
          admin_username = "admin";
          # Password for the admin user. It must be at least 10 characters.
          admin_password = "please-change-password";
          # Name of the site (can be changed later)
          site_name = "ATP's Lemmy";
        };
        pictrs = {
          # Address where pictrs is available (for image hosting)
          url = "http://${config.services.pict-rs.address}:${toString config.services.pict-rs.port}/";
          # TODO: Set a custom pictrs API key. ( Required for deleting images )
          # api_key = "";
        };
      };
    };
  };
  users.users.lemmy = {
    name = "lemmy";
    group = "lemmy";
    isSystemUser = true;
  };
  users.groups.lemmy = {};
}

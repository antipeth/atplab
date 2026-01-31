{config, ...}: let
  cfg = config.services.matrix-conduit;
in {
  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        address = "127.0.0.1";
        port = 6761;
        server_name = "example.com";
        database_backend = "sqlite";
        allow_federation = false;
        allow_registration = false;
        well_known = {
          client = "https://conduit.${cfg.settings.global.server_name}";
          server = "conduit.${cfg.settings.global.server_name}:443";
        };
      };
    };
  };
}

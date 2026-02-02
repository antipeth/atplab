{config, ...}: {
  services = {
    umami = {
      enable = true;
      createPostgresqlDatabase = true;
      settings = {
        APP_SECRET_FILE = /run/APP_SECRET_FILE;
        COLLECT_API_ENDPOINT = "/appui";
        TRACKER_SCRIPT_NAME = ["login.js"];
        HOSTNAME = "127.0.0.1";
        PORT = 3002;
        DISABLE_TELEMETRY = true;
        # REDIS_URL = "redis://${config.services.dragonflydb.bind}:${toString config.services.dragonflydb.port}";
      };
    };
  };
  users.users.umami = {
    name = "umami";
    group = "umami";
    isSystemUser = true;
  };
  users.groups.umami = {};
}

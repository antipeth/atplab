{
  services.gotify = {
    enable = true;
    environment = {
      GOTIFY_SERVER_PORT = 1245;
      GOTIFY_SERVER_LISTENADDR = "127.0.0.1";
      GOTIFY_DATABASE_DIALECT = "sqlite3";
      GOTIFY_REGISTRATION = "false";
    };
  };
}

_: {
  services.homebox = {
    enable = true;
    settings = {
      HBOX_MODE = "production";
      HBOX_WEB_HOST = "127.0.0.1";
      HBOX_WEB_PORT = "7745";
      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
      HBOX_STORAGE_DATA = "/var/lib/homebox/data";
      HBOX_DATABASE_TYPE = "sqlite3";
      HBOX_DATABASE_SQLITE_PATH = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
    };
  };
}

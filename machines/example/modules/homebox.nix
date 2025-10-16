_: {
  services = {
    homebox = {
      enable = true;
      database.createLocally = true;
      settings = {
        HBOX_MODE = "production";
        HBOX_WEB_HOST = "127.0.0.1";
        HBOX_WEB_PORT = "7745";
        HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
        HBOX_STORAGE_CONN_STRING = "file:///var/lib/homebox/data";
      };
    };
  };
}

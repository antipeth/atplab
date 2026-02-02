_: {
  services = {
    miniflux = {
      enable = true;
      adminCredentialsFile = /run/adminCredentialsFile;
      config = {
        CREATE_ADMIN = true;
        LISTEN_ADDR = "127.0.0.1:8080";
        WATCHDOG = false;
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

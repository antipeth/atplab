_: {
  services = {
    karakeep = {
      enable = true;
      extraEnvironment = {
        WORKERS_HOST = "127.0.0.1";
        PORT = "3003";
        DISABLE_SIGNUPS = "false";
        DISABLE_NEW_RELEASE_CHECK = "true";
      };
    };
  };
}

_: {
  services.immich = {
    enable = true;
    port = 2283;
    host = "localhost";
    machine-learning.enable = false;
    redis = {
      enable = true;
    };
    database = {
      enable = true;
      port = 5432;
    };
  };
}

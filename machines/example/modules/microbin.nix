_: {
  services = {
    microbin = {
      enable = true;
      passwordFile = /ruh/path;
      settings = {
        MICROBIN_BIND = "127.0.0.1";
        MICROBIN_PORT = 8080;
        MICROBIN_HASH_IDS = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
  };
}

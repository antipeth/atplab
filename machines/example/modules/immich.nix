_: {
  services = {
    immich = {
      enable = true;
      host = "127.0.0.1";
      machine-learning.enable = false;
      accelerationDevices = ["/dev/dri/renderD128"];
    };
  };
}

_: {
  services = {
    vigil-server = {
      enable = true;
      # environmentFile = /tmp/vigil;
      auth = {
        enable = true;
        adminPass = "test";
      };
    };
    vigil-agent = {
      enable = true;
      user = "root";
      group = "root";
    };
  };
}

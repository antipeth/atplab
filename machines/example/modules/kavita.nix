_: {
  services = {
    kavita = {
      enable = true;
      settings = {
        IpAddresses = "127.0.0.1";
        Port = 5000;
      };
      tokenKeyFile = /run/secret;
    };
  };
}

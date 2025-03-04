{
  services.webdav = {
    enable = true;
    user = "atp";
    group = "users";
    settings = {
      address = "192.168.6.173";
      port = 6065;
      prefix = "/";
      directory = "/share";
      users = [
        {
          # username = "{env}ENV_USERNAME";
          # password = "{env}ENV_PASSWORD";
          username = "admin";
          password = "admin";
          permissions = "CRUD";
        }
      ];
    };
  };
  networking.firewall = {
    # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [
      6065
    ];
    allowedUDPPorts = [
      6065
    ];
  };
}

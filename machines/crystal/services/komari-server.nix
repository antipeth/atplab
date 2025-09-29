{config, ...}: {
  sops.secrets = {
    crystal-komari-server-environment = {
      mode = "0440";
      owner = config.users.users.komari-server.name;
      group = config.users.users.komari-server.group;
    };
  };
  services.komari-server = {
    enable = true;
    host = "127.0.0.1";
    port = "25774";
    environmentFile = config.sops.secrets.crystal-komari-server-environment.path;
  };
}

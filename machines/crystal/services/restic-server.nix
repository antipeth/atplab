{config, ...}: {
  sops.secrets.crystal-restic-server-htpasswd = {
    mode = "0440";
    owner = config.users.users.restic.name;
    group = config.users.users.restic.group;
  };
  services.restic.server = {
    enable = true;
    htpasswd-file = config.sops.secrets.crystal-restic-server-htpasswd.path;
    listenAddress = "127.0.0.1:8081";
  };
}

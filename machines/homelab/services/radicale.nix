{ config, ... }:
{
  sops.secrets = {
    homelab-radicale-htpasswd = {
      mode = "0440";
      owner = config.users.users.radicale.name;
      group = config.users.users.radicale.group;
    };
  };
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "127.0.0.1:5232" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.sops.secrets.homelab-radicale-htpasswd.path;
        # hash function used for passwords. May be `plain` if you don't want to hash the passwords
        htpasswd_encryption = "bcrypt";
      };
    };
  };
}

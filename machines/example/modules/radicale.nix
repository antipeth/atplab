{config, ...}: {
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = ["127.0.0.1:5232"];
      auth = {
        type = "htpasswd";
        htpasswd_filename = /run/secret;
        # hash function used for passwords. May be `plain` if you don't want to hash the passwords
        htpasswd_encryption = "bcrypt";
      };
    };
    rights = {
      root = {
        user = ".+";
        collection = "";
        permissions = "R";
      };
      principal = {
        user = ".+";
        collection = "{user}";
        permissions = "RW";
      };
      calendars = {
        user = ".+";
        collection = "{user}/[^/]+";
        permissions = "rw";
      };
    };
  };
}

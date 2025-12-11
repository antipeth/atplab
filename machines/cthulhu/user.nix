{config, ...}: {
  sops.secrets.cthulhu-hashedPassword = {
    format = "binary";
    sopsFile = secrets/hashedPassword;
    neededForUsers = true;
  };
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.cthulhu-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import values/public-key.nix)
        ];
      };
    };
  };
}

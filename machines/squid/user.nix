{config, ...}: {
  # sops.secrets.squid-hashedPassword = {
  #   format = "binary";
  #   sopsFile = secrets/hashedPassword;
  #   neededForUsers = true;
  # };
  users = {
    mutableUsers = false;
    users = {
      root = {
        # hashedPasswordFile = config.sops.secrets.squid-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import values/public-key.nix)
        ];
      };
    };
  };
}

{config, ...}: {
  sops.secrets.icecream-hashedPassword.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.icecream-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import ../../sops/eval/icecream/public-key.nix)
        ];
      };
    };
  };
}

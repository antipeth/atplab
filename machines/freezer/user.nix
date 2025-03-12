{ config, ... }:
{
  sops.secrets.freezer-hashedPassword.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.freezer-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import ../../sops/eval/freezer/public-key.nix)
        ];
      };
    };
  };
}

{ config, ... }:
{
  sops.secrets.crystal-hashedPassword.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.crystal-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import ../../sops/eval/crystal/public-key.nix)
        ];
      };
    };
  };
}

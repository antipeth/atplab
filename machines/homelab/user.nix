{ config, ... }:
{
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.homelab-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import ../../sops/eval/homelab/public-key.nix)
        ];
      };
      atp = {
        isNormalUser = true;
        createHome = false;
        useDefaultShell = false;
      };
    };
  };
}

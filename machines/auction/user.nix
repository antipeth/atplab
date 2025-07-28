{config, ...}: {
  sops.secrets.auction-hashedPassword.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.auction-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import ../../sops/eval/auction/public-key.nix)
        ];
      };
    };
  };
}

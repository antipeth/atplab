{config, ...}: {
  sops.secrets.homelab-hashedPassword = {
    format = "binary";
    sopsFile = secrets/hashedPassword;
    neededForUsers = true;
  };
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.homelab-hashedPassword.path;
        openssh.authorizedKeys.keys = [
          (import ../../modules/private/homelab/public-key.nix)
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

{config, ...}: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          (import ../../sops/eval/octopus/public-key.nix)
        ];
      };
    };
  };
}

{ config, pkgs, ... }:
{
  sops.secrets = {
    homelab-aria2-rpc-secret = {
      mode = "0440";
      owner = config.users.users.aria2.name;
      group = config.users.users.aria2.group;
    };
  };
  services.aria2 = {
    enable = true;
    rpcSecretFile = config.sops.secrets.homelab-aria2-rpc-secret.path;
  };
  environment.systemPackages = [
    pkgs.ariang
  ];
}

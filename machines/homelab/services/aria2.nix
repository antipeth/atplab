{
  config,
  pkgs,
  ...
}: {
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
    settings = {
      # basic
      continue = true;
      max-concurrent-downloads = 5;
      quiet = true;
      # advanced
      allow-overwrite = true;
      auto-file-renaming = true;
      disk-cache = "64M";
      # http/ftp/sftp
      check-certificate = false;
      disable-ipv6 = true;
      max-connection-per-server = 16;
      min-split-size = "8M";
      split = 32;
      user-agent = "Transmission/2.77";
    };
  };
  environment.systemPackages = [
    pkgs.ariang
  ];
}

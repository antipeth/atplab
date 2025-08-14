{lib, ...}: {
  imports =
    [
      ./user.nix

      ../../modules/system/base.nix
      ../../modules/system/environment.nix
      ../../modules/system/minimalise.nix
      ../../modules/system/nix.nix
      ../../modules/system/zfs.nix

      # ../../modules/services/blacklist.nix
      # ../../modules/services/dns.nix
      # ../../modules/services/fail2ban.nix
      ../../modules/services/ssh.nix
      # ../../modules/services/tailscale.nix
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/options;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    zfs = {
      devNodes = "/dev/disk/by-path";
    };
  };

  # Enable networking
  networking = {
    hostId = "36e145c4";
    hostName = "test";
  };

  clan.core.networking.targetHost = "root@test";
}

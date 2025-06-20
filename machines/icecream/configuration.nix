{lib, ...}: {
  imports =
    [
      ./user.nix

      ../../modules/system/base.nix
      ../../modules/system/environment.nix
      ../../modules/system/minimalise.nix
      ../../modules/system/nix.nix
      ../../modules/system/zfs.nix

      ../../modules/services/blacklist.nix
      ../../modules/services/dns.nix
      ../../modules/services/fail2ban.nix
      ../../modules/services/ssh.nix
      # ../../modules/services/tailscale.nix

      # ./services/daed.nix
      ./services/power-management.nix
      ./services/router.nix
      ./services/wifi.nix
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/options;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking = {
    hostId = "2896c4e1";
    hostName = "icecream";
  };

  clan.core.networking.targetHost = "root@icecream";
}

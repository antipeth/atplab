{ lib, ... }:
{
  imports = [
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
    ../../modules/services/tailscale.nix

    ./services/power-management.nix
    # ./services/pve.nix
    ./vms/vm-network-tap.nix
  ] ++ lib.filesystem.listFilesRecursive ../../modules/options;

  boot = {
    loader = {
      grub = {
        configurationLimit = 50;
        device = "nodev";
        enable = true;
        efiInstallAsRemovable = true;
        efiSupport = true;
        zfsSupport = true;
      };
    };
  };

  # Enable networking
  networking = {
    hostId = "995f19e7";
    hostName = "freezer";
  };

  clan.core.networking.targetHost = "root@freezer";

}

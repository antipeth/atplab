{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = import ../../modules/private/homelab/disko-main-device.nix;
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./user.nix

      ../../modules/system/base.nix
      ../../modules/system/environment.nix
      ../../modules/system/minimalise.nix
      ../../modules/system/nix.nix
      ../../modules/system/zfs.nix

      # ../../modules/services/blacklist.nix
      ../../modules/services/dns.nix
      # ../../modules/services/fail2ban.nix
      ../../modules/services/ssh.nix
      # ../../modules/services/tailscale.nix
    ]
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "25.11";
  networking.hostId = "2aff655b";
}

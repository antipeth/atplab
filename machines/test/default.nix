{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-path/virtio-pci-0000:04:00.0";
in {
  imports =
    [
      ./user.nix
      ./hardware.nix

      ../../modules/system/base.nix
      ../../modules/system/environment.nix
      ../../modules/system/minimalise.nix
      ../../modules/system/nix.nix
      # ../../modules/system/zfs.nix

      # ../../modules/services/blacklist.nix
      # ../../modules/services/dns.nix
      # ../../modules/services/fail2ban.nix
      ../../modules/services/ssh.nix
      # ../../modules/services/tailscale.nix
    ]
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  networking.hostId = "36e145c4";
  system.stateVersion = "25.11";
}

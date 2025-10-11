{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-path/virtio-pci-0000:00:07.0";
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

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = true;
  };
  # disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "25.11";
  networking.hostId = "36e145c4";
}

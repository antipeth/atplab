{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-path/virtio-pci-0000:00:06.0";
in {
  imports =
    [
      ./disko.nix
      ./encrypt.nix
      ./hardware.nix
      ./network.nix
      ./user.nix

      # ./dn42
      ./values/5d34qGBR17c.nix

      ../../modules/services/zfs.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  boot.kernelParams = ["zfs.zfs_arc_max=2147483648"];
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "26.05";
  networking.hostId = "206f0a9a";
  swapDevices = [];
  zramSwap.enable = true;
}

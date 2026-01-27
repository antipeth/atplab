{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-path/virtio-pci-0000:00:07.0";
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./network.nix
      ./user.nix

      ../../modules/services/zfs.nix
      ./values/asbraglkgjia.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  boot.kernelParams = ["zfs.zfs_arc_max=1073741824"];
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "26.05";
  networking.hostId = "8ca7d4e1";
  swapDevices = [];
  zramSwap.enable = true;
}

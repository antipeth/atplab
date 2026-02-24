{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-path/virtio-pci-0000:07:00.0";
in {
  imports =
    [
      ./disko.nix
      ./encrypt.nix
      ./hardware.nix
      ./network.nix
      ./user.nix

      ../../modules/services/zfs.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  boot.kernelParams = ["zfs.zfs_arc_max=1610612736"];
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "26.05";
  networking.hostId = "87e87438";
  swapDevices = [];
  zramSwap.enable = true;
}

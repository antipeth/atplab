{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
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
  boot.kernelParams = ["zfs.zfs_arc_max=1073741824"];
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "26.05";
  networking.hostId = "54ce437b";
  swapDevices = [];
  zramSwap.enable = true;
}

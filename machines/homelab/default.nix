{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = import values/disko-main-device.nix;
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./user.nix

      ../../modules/services/zfs.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "25.11";
  networking.hostId = "2aff655b";
  boot.kernelParams = ["zfs.zfs_arc_max=21474836480"]; # Zfs arc is a beast, it would eat out all memory if you don't set limit!
  boot.zfs.devNodes = "/dev/disk/by-id";
}

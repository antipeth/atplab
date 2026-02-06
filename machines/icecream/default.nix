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
  system.stateVersion = "26.05";
  networking.hostId = "2896c4e1";
  boot.kernelParams = ["zfs.zfs_arc_max=4294967296"]; # Zfs arc is a beast, it would eat out all memory if you don't set limit!
  boot.zfs.devNodes = "/dev/disk/by-id";
}

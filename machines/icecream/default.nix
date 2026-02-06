{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = import values/disko-main-device.nix;
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./user.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "26.05";
  networking.hostId = "2896c4e1";
}

{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-id/xxxxxx";
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./network.nix
      ./user.nix
    ]
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "25.11";
  networking.hostId = "2aff655b";
}

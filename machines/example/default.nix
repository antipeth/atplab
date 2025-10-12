{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = import ../../modules/private/homelab/disko-main-device.nix;
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./user.nix
    ]
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "25.11";
  networking.hostId = "2aff655b";
}

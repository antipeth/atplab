{lib, ...}: let
  ls = lib.filesystem.listFilesRecursive;
  primary-disk = "/dev/disk/by-path/virtio-pci-0000:07:00.0";
in {
  imports =
    [
      ./disko.nix
      ./hardware.nix
      ./network.nix
      ./user.nix

      ./dn42
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot.loader.limine.biosDevice = primary-disk;
  disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "26.05";
  networking.hostId = "87e87438";
  swapDevices = [];
  zramSwap.enable = true;
}

{
  lib,
  pkgs,
  ...
}: let
  ls = lib.filesystem.listFilesRecursive;
  # primary-disk = "/dev/disk/by-id/xxxxxx";
in {
  imports =
    [
      ./hardware.nix
      ./network.nix
      ./user.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/system
    ++ ls ../../modules/options;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        configurationLimit = 10;
        enable = true;
        device = "nodev";
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };
  # boot.loader.limine.biosDevice = primary-disk;
  # disko.devices.disk.main.device = primary-disk;
  system.stateVersion = "25.11";
  networking.hostId = "458eb6b8";
  swapDevices = [
    {
      device = "/swapfile";
      size = 1076;
    }
  ];
  zramSwap.enable = true;
}

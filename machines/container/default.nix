{
  lib,
  pkgs,
  ...
}: let
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      #   ../../modules/system/dns.nix
      #   ../../modules/system/networking.nix
      ../../modules/system/environment.nix
    ]
    # ++ ls ./modules
    # ls ../../modules/system
    ++ ls ../../modules/options;

  boot.isContainer = true;
  system.stateVersion = "25.11";
}

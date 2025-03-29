{ lib, pkgs, ... }:
let
  inherit (import ../env.nix) TV_MODE;
in
lib.mkIf TV_MODE {
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.desktopManager.kodi.package = pkgs.kodi.withPackages (
    pkgs: with pkgs; [
      jellycon
    ]
  );
  services.displayManager.autoLogin.user = "kodi";

  services.xserver.displayManager.lightdm.greeter.enable = false;

  # Define a user account
  users.extraUsers.kodi.isNormalUser = true;


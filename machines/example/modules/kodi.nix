{pkgs, ...}: {
  # Define a user account
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.desktopManager.kodi.package = pkgs.kodi-wayland.withPackages (exts:
    with exts; [
      # Gamepad driver
      jellycon
      joystick
    ]);
  services.displayManager.autoLogin.user = "kodi";
  services.xserver.displayManager.lightdm.greeter.enable = false;

  # Define a user account
  users.extraUsers.kodi.isNormalUser = true;
}

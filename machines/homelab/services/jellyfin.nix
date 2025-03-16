{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    dataDir = "/media/jellyfin";
    cacheDir = "/var/cache/jellyfin";
    configDir = "/var/lib/jellyfin/config";
    user = "atp";
    group = "users";
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}

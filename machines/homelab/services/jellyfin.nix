{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
    dataDir = "/var/lib/jellyfin";
    cacheDir = "/var/cache/jellyfin";
    configDir = "/var/lib/jellyfin/config";
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.nvtopPackages.amd
    pkgs.yazi
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/media";
    cacheDir = "/var/cache/jellyfin";
    configDir = "var/lib/jellyfin/config";
  };
}

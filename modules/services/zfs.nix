{
  lib,
  pkgs,
  ...
}: {
  boot = {
    supportedFilesystems = ["zfs"];
    kernelParams = [
      "zfs_force=1"
    ];
    zfs = {
      package = pkgs.zfs_unstable;
      forceImportRoot = false;
      devNodes = lib.mkDefault "/dev/disk/by-path";
    };
  };
  # Where hostID can be generated with:
  # head -c4 /dev/urandom | od -A none -t x4
  # networking.hostId = "xxxxxxxx";
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    trim = {
      enable = true; # hdd no need
      interval = "weekly";
    };
  };
  systemd.services = {
    zfs-share.enable = lib.mkForce false;
    zfs-zed.enable = lib.mkForce false;
  };
}

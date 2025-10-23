{
  inputs,
  lib,
  ...
}: {
  boot = {
    supportedFilesystems = ["zfs"];
    kernelParams = [
      "zfs_force=1"
    ];
    zfs = {
      forceImportRoot = false;
      devNodes = lib.mkDefault "/dev/disk/by-path";
      package = inputs.chaotic.legacyPackages.x86_64-linux.zfs_cachyos;
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
    autoSnapshot.enable = true;
  };
  systemd.services = {
    zfs-share.enable = lib.mkForce false;
    zfs-zed.enable = lib.mkForce false;
  };
}

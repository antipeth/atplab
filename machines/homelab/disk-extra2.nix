_: {
  fileSystems."/mnt/hdd3" = {
    device = import ../../sops/eval/homelab/disko-hdd3-device.nix;
    fsType = "f2fs";
    options = [
      # Continute when it failed
      "nofail"
      # Enable compress
      "compress_algorithm=zstd:6"
      "compress_chksum"
      # Enable better garbage collector
      "gc_merge"
      # Do not synchronously update access or modification times
      "lazytime"
    ];
  };
  systemd.tmpfiles.rules = [
    "d /mnt/hdd3 0755 atp users - -"
  ];
}

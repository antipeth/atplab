{lib, ...}: {
  services.scx = lib.mkDefault {
    enable = true;
    scheduler = "scx_bpfland";
  };
}

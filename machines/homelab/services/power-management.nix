{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = inputs.chaotic.legacyPackages.x86_64-linux.linuxPackages_cachyos-server;
    zfs.package = inputs.chaotic.legacyPackages.x86_64-linux.zfs_cachyos;
    kernelParams = [
      # "amd_pstate=passive"
      "pcie_aspm=force"
    ];
  };
  environment.systemPackages = [
    config.boot.kernelPackages.cpupower
    config.boot.kernelPackages.turbostat
  ];
  # Hard Driver
  services.udev.extraRules =
    let
      mkRule = as: lib.concatStringsSep ", " as;
      mkRules = rs: lib.concatStringsSep "\n" rs;
    in
    mkRules ([
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 12 /dev/%k"''
      ])
    ]);
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
}

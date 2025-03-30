{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
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

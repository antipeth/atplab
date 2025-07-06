{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelPackages = inputs.chaotic.legacyPackages.x86_64-linux.linuxPackages_cachyos-server;
    zfs.package = inputs.chaotic.legacyPackages.x86_64-linux.zfs_cachyos;
    kernelParams = [
      # "amd_pstate=passive"
      # "intel_pstate=active"
      "pcie_aspm=force"
      # "pcie_aspm.policy=powersave"
      # "intel_idle.max_cstate=10"
      # "processor.max_cstate=10"
      # "i915.enable_rc6=7"
      # "i915.enable_fbc=1"
      # "i915.lvds_downclock=1"
    ];
    # extraModprobeConfig = ''
    #   options snd_hda_intel power_save=1
    #   options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
    #   options iwldvm force_cam=0
    # '';
    # kernel.sysctl = {
    #   "kernel.nmi_watchdog" = 0;
    #   "vm.dirty_writeback_centisecs" = 6000;
    #   # "vm.laptop_mode" = 5;
    # };
  };
  # environment.systemPackages = [
  # config.boot.kernelPackages.cpupower
  # config.boot.kernelPackages.turbostat
  # ];
  services.udev.extraRules = let
    mkRule = as: lib.concatStringsSep ", " as;
    mkRules = rs: lib.concatStringsSep "\n" rs;
  in
    mkRules [
      # Hard Driver
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 12 /dev/%k"''
      ])
      # Network Interfaces
      # (mkRule [
      #   ''ACTION=="add"''
      #   ''SUBSYSTEM=="net"''
      #   ''KERNEL=="eth*"''
      #   ''RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"''
      # ])
      # (mkRule [
      #   ''ACTION=="add"''
      #   ''SUBSYSTEM=="net"''
      #   ''KERNEL=="wlan*"''
      #   ''RUN+="${pkgs.iw}/bin/iw dev %k set power_save on"''
      # ])
      # PCI Device Runtime Power Management
      # (mkRule [
      #   ''ACTION=="add"''
      #   ''SUBSYSTEM=="pci"''
      #   ''ATTR{power/control}="auto"''
      # ])
      # SCSI Host (SATA/AHCI) Link Power Management
      # (mkRule [
      #   ''ACTION=="add"''
      #   ''SUBSYSTEM=="scsi_host"''
      #   ''KERNEL=="host*"''
      #   ''KERNEL=="host*", ATTR{link_power_management_policy}="min_power"''
      # ])
    ];
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
  # services = {
  #   scx = {
  #     enable = true;
  #     scheduler = "scx_simple";
  #   };
  # };
}

{
  lib,
  pkgs,
  ...
}: {
  boot = {
    blacklistedKernelModules = [
      "cfg80211" # Disable wifi
      "nvidiafb"
      "nouveau"
      "nvidia"
      "radeon"
      # "amdgpu"
      "snd_hda_intel" # Disable audio
      "snd_hda_codec_hdmi"
      "i915"
    ];
    kernelParams = [
      "pcie_aspm=force"
    ];
  };
  # Hard Driver
  services.udev.extraRules = let
    mkRule = as: lib.concatStringsSep ", " as;
    mkRules = rs: lib.concatStringsSep "\n" rs;
  in
    mkRules [
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 /dev/%k"''
      ])
      (mkRule [
        ''ACTION=="add"''
        ''SUBSYSTEM=="pci"''
        ''DRIVER=="pcieport"''
        ''ATTR{power/wakeup}="disabled"''
      ])
    ];
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
  services.scx = {
    enable = false;
  };
}

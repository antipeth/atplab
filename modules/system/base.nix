{
  lib,
  pkgs,
  ...
}: {
  boot = {
    consoleLogLevel = lib.mkForce 0;
    extraModprobeConfig = "blacklist mei mei_hdcp mei_me mei_pxp iTCO_wdt pstore sp5100_tco";
    initrd = {
      compressor = "zstd";
      compressorArgs = [
        "-T0"
        "-19"
        "--long"
      ];
      systemd.enable = true;
      verbose = false;
    };
    # Kernel
    kernel = {
      sysctl = {
        # bbr
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "fq";
        "net.core.wmem_max" = 1073741824;
        "net.core.rmem_max" = 1073741824;
        "net.ipv4.tcp_rmem" = "4096 87380 1073741824";
        "net.ipv4.tcp_wmem" = "4096 87380 1073741824";
      };
    };
    kernelModules = ["tcp_bbr"];
    kernelParams = [
      "audit=0"
      "console=tty0"
      "debugfs=off"
      "net.ifnames=0"
      "erst_disable"
      "nmi_watchdog=0"
      "noatime"
      "nowatchdog"
      "quiet"
    ];
    tmp.cleanOnBoot = true;
  };

  console.keyMap = "us";

  # Set your time zone.
  time = {
    timeZone = "Asia/Singapore";
    hardwareClockInLocalTime = false;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking = {
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [
        222
        443
      ];
    };
    timeServers = [
      "ntppool1.time.nl"
      "ntppool2.time.nl"
      "ntp.ripe.net"
    ];
  };
  services = {
    timesyncd.enable = false;
    ntpd-rs.enable = true;
  };

  system.stateVersion = "25.05";
}

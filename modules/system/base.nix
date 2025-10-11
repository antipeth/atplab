{
  inputs,
  lib,
  ...
}:
with lib; {
  boot = {
    loader = mkDefault {
      limine = {
        biosSupport = true;
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = true;
        maxGenerations = 10;
        partitionIndex = 1;
      };
    };
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
        # Disable automatic core dumps
        "kernel.core_pattern" = "|/bin/false";

        # bbr
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "fq";

        # buffer size
        # see https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
        "net.core.wmem_max" = 1073741824;
        "net.core.rmem_max" = 1073741824;

        # tune tcp
        # see https://blog.cloudflare.com/optimizing-tcp-for-high-throughput-and-low-latency
        "net.ipv4.tcp_adv_win_scale" = -2;
        "net.ipv4.tcp_collapse_max_bytes" = 6291456;
        "net.ipv4.tcp_fack" = 1;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_notsent_lowat" = 131072;
        "net.ipv4.tcp_rmem" = "8192 262144 536870912";
        "net.ipv4.tcp_wmem" = "4096 16384 536870912";

        # DN42
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.default.forwarding" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv4.conf.default.rp_filter" = 0;
        "net.ipv4.conf.all.rp_filter" = 0;

        # Disable IPv6 router advertisements to prevent conflicting routes
        "net.ipv6.conf.eth0.accept_ra" = false;
        "net.ipv6.conf.eth0.autoconf" = false;
      };
    };
    kernelModules = ["tcp_bbr"];
    kernelPackages = mkDefault inputs.chaotic.legacyPackages.x86_64-linux.linuxPackages_cachyos-server;
    kernelParams = [
      "audit=0"
      "console=tty1"
      "debugfs=off"
      "erst_disable"
      "net.ifnames=0"
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

  networking = {
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [
        222
        443
      ];
    };
  };
}

{config, ...}: {
  boot.kernel.sysctl = {
    # if you use ipv4, this is all you need
    "net.ipv4.conf.all.forwarding" = true;

    # If you want to use it for ipv6
    "net.ipv6.conf.all.forwarding" = true;

    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
  };
  networking = {
    bridges.switch-br.interfaces = ["eth0" "eth1" "wlan0"];
    firewall.enable = false;
    interfaces = {
      switch-br = {
        useDHCP = true;
      };
    };
  };
  services = {
    hostapd = {
      enable = true;
      radios = {
        wlan0 = {
          band = "2g";
          channel = 11; # ACS

          wifi6.enable = true;

          networks = {
            wlan0 = {
              ssid = "test";
              authentication = {
                mode = "wpa3-sae";
                saePasswordsFile = config.sops.secrets.icecream-wifi-password.path;
              };
              # bssid = "36:b9:ff:ff:ff:ff";
            };
          };
          settings = {
            bridge = "switch-br";
          };
        };
      };
    };
  };
}
